# Brevo Email Integration Setup

This guide will help you set up Brevo (formerly Sendinblue) email integration for the contact form.

## Step 1: Create a Brevo Account

1. Go to [https://app.brevo.com/](https://app.brevo.com/)
2. Sign up for a free account or log in if you already have one
3. Complete the account verification process

## Step 2: Get Your API Key

1. Once logged in, go to **Settings** (gear icon in the top right)
2. Click on **API Keys** in the left sidebar
3. Click **Create a new API key**
4. Give it a name like "GPL Website Contact Form"
5. Copy the generated API key

## Step 3: Configure the Environment Variable

1. Open the `.env.local` file in the website root directory
2. Replace `your_brevo_api_key_here` with your actual API key:
   ```
   BREVO_API_KEY=xkeysib-your-actual-api-key-here
   ```
3. Save the file

## Step 4: Verify Email Settings

The contact form is configured to:
- Send admin notifications to: `mumerfarooqlaghari@gmail.com`
- Send auto-replies from: `noreply@globalprogrammingleague.com`

To change the admin email:
1. Open `src/app/api/contact/route.ts`
2. Find the line with `mumerfarooqlaghari@gmail.com`
3. Replace it with your desired email address

## Step 5: Test the Contact Form

1. Start the development server: `npm run dev`
2. Navigate to the Contact page
3. Fill out and submit the form
4. Check your email for both the admin notification and auto-reply

## Brevo Free Plan Limits

- 300 emails per day
- Brevo branding in emails
- Basic email templates

For production use, consider upgrading to a paid plan for:
- Higher email limits
- Custom branding
- Advanced features

## Troubleshooting

### Common Issues:

1. **"Email service not configured" error**
   - Make sure the `BREVO_API_KEY` is set in `.env.local`
   - Restart the development server after adding the API key

2. **"Failed to send email" error**
   - Verify your API key is correct
   - Check that your Brevo account is active
   - Ensure you haven't exceeded daily email limits

3. **Emails not being received**
   - Check spam/junk folders
   - Verify the recipient email address is correct
   - Check Brevo dashboard for delivery status

### Getting Help:

- Brevo Documentation: [https://developers.brevo.com/](https://developers.brevo.com/)
- Brevo Support: Available through your Brevo dashboard

## Security Notes

- Never commit your actual API key to version control
- The `.env.local` file is already in `.gitignore`
- Use environment variables for production deployment
- Consider using different API keys for development and production
