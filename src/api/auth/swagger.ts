
export const AuthSwaggerDocs = {
  components: {
    schemas: {
      LoginResponse: {
        type: "object",
        properties: {
          status: {
            type: "string",
            description: "The status of the operation, typically 'success' or 'error'.",
          },
          message: {
            type: "string",
            description: "A message describing the outcome of the operation.",
          },
          user: {
            type: "object",
            properties: {
              id: {
                type: "integer",
                description: "User ID",
              },
              phone: {
                type: "string",
                description: "User's phone number",
              },
              password: {
                type: "string",
                description: "User's password",
              },
            },
            description: "User details",
          },
          accessToken: {
            type: "string",
            description: "JWT access token used for authenticated requests",
          },
          refreshToken: {
            type: "string",
            description: "JWT refresh token used to obtain a new access token",
          },
        },
        description: "Response body returned after successful authentication",
      },
    },
  },    
  paths: { 
    "/login": {
      post: {
        tags: ["Auths"],
        summary: "Login",
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: {
                type: "object",
                required: ["username", "password"],
                properties: {
                  username: {
                    type: "string",
                    description: "username",
                    example: "thavisouk",
                  },
                  password: {
                    type: "string",
                    description: "Password",
                    example: "Lit@2024",
                  },
                },
              },
            },
          },
        },
        responses: {
          200: {
            description: "Logined successfully",
            content: {
              "application/json": {
                schema: { $ref: "#/components/schemas/LoginResponse" },
              },
            },
          },
        },
      },
    },
  },
};
