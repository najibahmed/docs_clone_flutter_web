const AuthService = require('../services/authService');
const jwt = require('jsonwebtoken');
const authService = new AuthService();


module.exports = class AuthController {
    async RegisterUser(req, res) {
        try {
            const { name, email, profilePic } = req.body;
            if (name == null || email == null || profilePic == null) {
                return res.status(400).json({ message: "All fields are required !!" });
            }
            let existUser = await authService.findUserByEmail(email);
            if (!existUser) {
                // return res.status(400).json({ message: "User already exist!" });
                const response = await authService.registerUser(name, email, profilePic);
                const token = jwt.sign({ id: response._id }, process.env.JWT_SECRET);
                res.status(200).json({
                    message: "User created.",
                    user: response,
                    token: token
                });
            }
            console.log(`existUser Id RegisterUser: ${existUser._id}`);
            const token = jwt.sign({ id: existUser._id }, process.env.JWT_SECRET);
    
                res.status(200).json({
                    message: "User created.",
                    user: existUser,
                    token: token
                });


        } catch (error) {
            console.log(error);
            res.status(500).json({
                error: "Internal Server error:",
            });
        }
    }

    async GetUser(req, res) {
        try {
            const user = await authService.findUserById(req.user);
            const token = req.token;
            res.status(200).json({
                message: "User found.",
                user: user,
                token: token
            });

        } catch (error) {
            console.log(error);
            res.status(500).json({
                error: "Internal Server error:",
            });

        }
    }



}