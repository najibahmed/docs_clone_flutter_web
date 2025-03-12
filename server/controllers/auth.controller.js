const AuthService = require('../services/authService');
const authService = new AuthService();


module.exports = class AuthController {
    async RegisterUser(req, res) {
        try {
            const { name, email, profilePic } = req.body;
            if(name==null || email==null || profilePic==null){
                return res.status(400).json({ message: "All fields are required !!" });
            }
            let existUser = await authService.findUserByEmail(email);
            if (existUser) {
                return res.status(400).json({ message: "User already exist!" });
            }
            const response = await authService.registerUser(name, email, profilePic);
            res.status(200).json({
                message: "User created.",
                user: response,
              });
        } catch (error) {
            console.log(error);
            res.status(500).json({
                error: "Internal Server error:",
              });
        }
    }



}