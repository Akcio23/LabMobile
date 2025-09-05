import pkg from 'jsonwebtoken'
import 'dotenv/config'

const { verify } = pkg

const key = process.env.KEY || "Definir Key"

function verifyAuth(req, res, next) {
    const authToken = req.headers.authorization

    if (authToken) {
        const [, token] = authToken.split(' ')

        try {
            verify(token, key)

            return next()
        } catch (err) {
            return res.status(401).json({
                message: 'Unauthorized',
            })
        }
    }

    return res.status(401).json({
        message: 'Unauthorized',
    })
}

export default verifyAuth