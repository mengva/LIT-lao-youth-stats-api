import { Request, Response } from "express";
import rateLimit from "express-rate-limit";
import { StatusCodes } from "http-status-codes";

const rateLimitExceededHandler = (req: Request, res: Response) => {
  res.status(StatusCodes.TOO_MANY_REQUESTS).json({
    status: "error",
    message: "Too many requests, please try again later.",
  });
};
const SECONDS_IN_MINUTE = 60;
const MILLISECONDS_IN_SECOND = 1000;
const MAX_REQUESTS = 100;

export const speedLimiter = rateLimit({
  windowMs: 1 * SECONDS_IN_MINUTE * MILLISECONDS_IN_SECOND,
  max: MAX_REQUESTS,
  standardHeaders: "draft-7",
  legacyHeaders: false,
  handler: rateLimitExceededHandler,
  skip: () => {
    return false;
  },
});
