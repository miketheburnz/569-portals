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
      roomId,
      guestName,
      guestEmail,
      guestPhone,
      checkInDate,
      checkOutDate,
      numberOfGuests,
      source = "Direct",
      notes = "",
    } = body;

    if (!roomId || !guestName || !guestPhone || !checkInDate || !checkOutDate) {
      return new Response(
        JSON.stringify({ error: "Missing required fields" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const { data: room } = await supabase
      .from("rooms")
      .select("*")
      .eq("id", roomId)
      .maybeSingle();

    if (!room) {
      return new Response(
        JSON.stringify({ error: "Room not found" }),
        {
          status: 404,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const checkIn = new Date(checkInDate);
    const checkOut = new Date(checkOutDate);
    const nights = Math.ceil((checkOut.getTime() - checkIn.getTime()) / (1000 * 60 * 60 * 24));
    const rate = room.rate_per_night;
    const totalAmount = nights * rate;

    const { count } = await supabase.from("bookings").select("*", { count: "exact", head: true });
    const bookingNumber = (count || 0) + 1;
    const bookingRef = `BK${String(bookingNumber).padStart(4, "0")}`;

    const { data: booking, error } = await supabase
      .from("bookings")
      .insert([
        {
          booking_ref: bookingRef,
          room_id: roomId,
          guest_name: guestName,
          guest_email: guestEmail,
          guest_phone: guestPhone,
          check_in_date: checkInDate,
          check_out_date: checkOutDate,
          number_of_guests: numberOfGuests,
          source,
          notes,
          rate_per_night: rate,
          total_amount: totalAmount,
          status: "Confirmed",
        },
      ])
      .select()
      .single();

    if (error) {
      throw error;
    }

    await supabase.from("housekeeping_tasks").insert([
      {
        task_date: checkInDate,
        room_id: roomId,
        task_type: "Full Turnover",
        priority: "Urgent",
        status: "Pending",
        notes: `Prepare for guest ${guestName} - Check-in at 14:00`,
      },
    ]);

    return new Response(
      JSON.stringify({
        success: true,
        booking: booking,
        message: `Booking ${bookingRef} created successfully`,
      }),
      {
        status: 201,
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