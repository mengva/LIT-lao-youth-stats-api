import Router from "express";

import authRouter from "./api/auth/router";
import userRouter from "./api/user/router";

import {
  createLoginSwaggerController,
  swaggerLoginController,
} from "./swaggers/controller";

const router = Router();

router.use(userRouter);
router.use(authRouter);

router.get("/swagger-login", createLoginSwaggerController);
router.post("/swagger-login", swaggerLoginController);

export default router;
