const jwt = require('jsonwebtoken');

const auth = (req, res, next) => {
    const token = req.headers.authorization;

    if (!token || !token.startsWith('Bearer ')) {
        return res.status(401).json({
            status: false,
            message: 'Token tidak ditemukan'
        });
    }

    try {
        const decoded = jwt.verify(
            token.split(' ')[1],
            process.env.JWT_SECRET
        );

        req.user = decoded;
        next();

    } catch (error) {
        return res.status(401).json({
            status: false,
            message: 'Token tidak valid'
        });
    }
};

module.exports = auth;