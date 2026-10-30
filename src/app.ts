
import cookieParser from "cookie-parser";
import cors from "cors";
import express, { NextFunction, Request, Response } from "express";
import { join } from "path";
import prom from "prom-client";
import requestIp from "request-ip";
import { logRequestResponse } from "./middleware/logger/logger-middleware";
import router from "./routes";
import { swaggerRedirectController } from "./swaggers/controller";
import { swaggerVerify } from "./swaggers/jwt";
import { configureSwagger } from "./swaggers/swagger-config";
import env from "./utils/env";
import { helpCheck } from "./utils/helpCheck";
import { speedLimiter } from "./utils/limiter";

const app = express();

const register = new prom.Registry();
register.setDefaultLabels({
  worker: env.SERVICE_NAME,
});
const collectDefaultMetrics = prom.collectDefaultMetrics;
collectDefaultMetrics({
  labels: { NODE_APP_INSTANCE: process.env.NODE_APP_INSTANCE },
  register,
});

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.set("trust proxy", true);
app.set("trust proxy", "loopback");
app.use(speedLimiter);
app.use(requestIp.mw());
app.use(cookieParser());
configureSwagger(app);

app.use((req: Request, res: Response, next: NextFunction) =>
  logRequestResponse(req, res, next, ["excel", "users", "metrics"]),
);

app.get("/", helpCheck);

app.use(router);
app.use(express.static(join(env.PWD, "uploads")));
app.get("/swagger", swaggerVerify, swaggerRedirectController);

app.get("/metrics", async (req, res) => {
  res.set("Content-Type", register.contentType);
  res.send(await register.metrics());
});

export default app;
