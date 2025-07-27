import { NextRequest, NextResponse } from 'next/server';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { name, email, phone, inquiryType, subject, message } = body;

    // Validate required fields
    if (!name || !email || !inquiryType || !subject || !message) {
      return NextResponse.json(
        { error: 'Missing required fields' },
        { status: 400 }
      );
    }

    // Brevo API configuration
    const BREVO_API_KEY = process.env.BREVO_API_KEY;
    const BREVO_API_URL = 'https://api.brevo.com/v3/smtp/email';

    if (!BREVO_API_KEY) {
      console.error('BREVO_API_KEY is not configured');
      return NextResponse.json(
        { error: 'Email service not configured' },
        { status: 500 }
      );
    }

    // Email content for the admin notification
    const adminEmailContent = `
      <h2>New Contact Form Submission</h2>
      <p><strong>Name:</strong> ${name}</p>
      <p><strong>Email:</strong> ${email}</p>
      <p><strong>Phone:</strong> ${phone || 'Not provided'}</p>
      <p><strong>Inquiry Type:</strong> ${inquiryType}</p>
      <p><strong>Subject:</strong> ${subject}</p>
      <p><strong>Message:</strong></p>
      <p>${message.replace(/\n/g, '<br>')}</p>
      <hr>
      <p><em>This email was sent from the Global Programming League contact form.</em></p>
    `;

    // Auto-reply email content for the user
    const userEmailContent = `
      <h2>Thank you for contacting Global Programming League!</h2>
      <p>Dear ${name},</p>
      <p>We have received your inquiry regarding: <strong>${subject}</strong></p>
      <p>Our team will review your message and get back to you within 24-48 hours.</p>
      
      <h3>Your Message Summary:</h3>
      <p><strong>Inquiry Type:</strong> ${inquiryType}</p>
      <p><strong>Subject:</strong> ${subject}</p>
      <p><strong>Message:</strong> ${message}</p>
      
      <p>If you have any urgent questions, please don't hesitate to contact us directly at mumerfarooqlaghari@gmail.com</p>
      
      <p>Best regards,<br>
      The Global Programming League Team</p>
      
      <hr>
      <p><em>This is an automated response. Please do not reply to this email.</em></p>
    `;

    // Send admin notification email
    const adminEmailPayload = {
      sender: {
        name: "GPL Contact Form",
        email: "noreply@globalprogrammingleague.com"
      },
      to: [
        {
          email: "mumerfarooqlaghari@gmail.com",
          name: "GPL Admin"
        }
      ],
      subject: `New Contact Form: ${subject}`,
      htmlContent: adminEmailContent,
      replyTo: {
        email: email,
        name: name
      }
    };

    // Send auto-reply email to user
    const userEmailPayload = {
      sender: {
        name: "Global Programming League",
        email: "noreply@globalprogrammingleague.com"
      },
      to: [
        {
          email: email,
          name: name
        }
      ],
      subject: "Thank you for contacting Global Programming League",
      htmlContent: userEmailContent
    };

    // Send both emails
    const [adminResponse, userResponse] = await Promise.all([
      fetch(BREVO_API_URL, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'api-key': BREVO_API_KEY
        },
        body: JSON.stringify(adminEmailPayload)
      }),
      fetch(BREVO_API_URL, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'api-key': BREVO_API_KEY
        },
        body: JSON.stringify(userEmailPayload)
      })
    ]);

    if (!adminResponse.ok || !userResponse.ok) {
      const adminError = !adminResponse.ok ? await adminResponse.text() : null;
      const userError = !userResponse.ok ? await userResponse.text() : null;
      
      console.error('Brevo API Error:', { adminError, userError });
      return NextResponse.json(
        { error: 'Failed to send email' },
        { status: 500 }
      );
    }

    return NextResponse.json(
      { message: 'Contact form submitted successfully' },
      { status: 200 }
    );

  } catch (error) {
    console.error('Contact form error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
