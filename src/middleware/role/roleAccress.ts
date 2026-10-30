import { Request } from "express";
import { Roles } from "../../api/user/types";

function isRoleAuthorized(userRoles: Roles[], requiredRoles: Roles[]): boolean {
  return userRoles.some((role) => requiredRoles.includes(role));
}

import { RequestHandler } from "express";
import { StatusCodes } from "http-status-codes";

export function roleAccess(role: Roles[]): RequestHandler {
  return async (req, res, next): Promise<void> => {
    try {
      const payload = tokenPayloadService(req);
      const userRoles = payload.role as Roles[];
      if (!isRoleAuthorized(userRoles, role)) {
        res.status(StatusCodes.FORBIDDEN).json({
          status: "error",
          message:
            "Access denied: You do not have the required permissions to perform this action.",
        });
        return;
      }
      next();
    } catch {
      res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
        status: "error",
        message:
          "An internal server error occurred while validating your permissions. Please try again later.",
      });
    }
  };
}

export const tokenPayloadService = (req: Request) => {
  // @ts-ignore
  const payload: TokenPayload = req.tokenPayload;
  return payload;
};
