const admin = require("../firebaseAdmin");

const sendNotification = async (req, res) => {
    try {
        const { title, body, token } = req.body;

        const message = {
            notification: {
                title: title,
                body: body,
            },
            token: token,
        };

        await admin.messaging().send(message);
        res.status(200).json({ success: true, message: "Notification sent successfully" });

    } catch (error) {
        console.error("Error sending notification:", error);
        res.status(500).json({ success: false, error: error.message });
    }
};

module.exports = { sendNotification };
