
const UserModel = require('../models/user.model');

module.exports = class AuthService {
    async registerUser(name, email, profilePic) {
        const user = new UserModel({
            name: name,
            email: email,
            profilePic: profilePic
        });
        return await user.save();
    }

    async findUserByEmail(email) {
        const user = await UserModel.findOne({ email });
        return user;
    }
    async findUserById(id) {
            const user = await UserModel.findById(id);
            return user;
    }
};