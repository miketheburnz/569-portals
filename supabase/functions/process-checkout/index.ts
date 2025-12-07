import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 200,
      headers: corsHeaders,
    });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !supabaseServiceKey) {
      throw new Error("Missing Supabase configuration");
    }

    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const body = await req.json();

    const {
      bookingId,
      inspection,
      damageNotes,
      depositAction,
      balance,
    } = body;

    if (!bookingId) {
      return new Response(
        JSON.stringify({ error: "Missing booking ID" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const { data: booking } = await supabase
      .from("bookings")
      .select("*")
      .eq("id", bookingId)
      .maybeSingle();

    if (!booking) {
      return new Response(
        JSON.stringify({ error: "Booking not found" }),
        {
          status: 404,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    await supabase
      .from("guests")
      .update({
        checked_out: true,
        check_out_time: new Date().toISOString(),
      })
      .eq("booking_id", bookingId);

    let depositAmount = 500;
    if (depositAction === "Partial") {
      depositAmount = 250;
    } else if (depositAction === "Forfeit") {
      depositAmount = 0;
    }

    const { error: updateError } = await supabase
      .from("bookings")
      .update({
        status: "Checked-Out",
        updated_at: new Date().toISOString(),
      })
      .eq("id", bookingId);

    if (updateError) {
      throw updateError;
    }

    if (depositAmount > 0) {
      await supabase.from("income").insert([
        {
          transaction_date: new Date().toISOString().split('T')[0],
          description: `Deposit refund - ${booking.guest_name}`,
          category: "Deposit",
          amount: depositAmount,
          payment_method: "Refund",
          booking_id: bookingId,
          notes: damageNotes,
        },
      ]);
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: "Guest checked out successfully",
        depositRefunded: depositAmount,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : "Unknown error";
    return new Response(
      JSON.stringify({ error: message }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});