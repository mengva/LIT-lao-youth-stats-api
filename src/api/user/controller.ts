/* eslint-disable no-magic-numbers */
import { Request, Response } from "express";
import { StatusCodes } from "http-status-codes";

import logger from "../../middleware/logger/config";
import {
  buildNewUser,
  buildUserRecord,
  hashPassword,
  isPhoneNumberTaken,
} from "./lib";

import { ActionType } from "@prisma/client";
import { sendErrorResponse, sendSuccessResponse } from "../../api/lib";
import { prisma } from "../../prisma";
import { dataTokenPayload } from "../../utils/lib";
import {
  createUserervice,
  createUserLogService,
  findUserervice,
  getAggregationUserListServices,
  getAllUserService,
  getOneuserervices,
  getUserLogService,
  updateUserAccountService,
} from "./service";

export const getManyUserController = async (req: Request, res: Response) => {
  try {
    const result = await getAllUserService(req);
    res.json({
      status: "ok",
      message: "success",
      ...result,
    });
  } catch (error) {
    logger.error(error);
    res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
      status: "error",
      message: "Failed to fetch folder",
    });
  }
};

export const getUserLogController = async (req: Request, res: Response) => {
  try {
    const result = await getUserLogService(req);
    res.json({
      status: "ok",
      message: "success",
      ...result,
    });
  } catch (error) {
    logger.error(error);
    res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
      status: "error",
      message: "Failed to fetch office logs",
    });
  }
};

export const getOneUserController = async (req: Request, res: Response) => {
  try {
    const id = Number(req.params.id);
    if (isNaN(id) || id <= 0) {
      res.status(400).json({ status: "error", message: "Invalid user ID" });
      return;
    }
    const user = await getOneuserervices({ id });
    if (!user) {
      res.status(404).json({ status: "error", message: "User not found" });
      return;
    }
    res.json({ status: "ok", message: "User retrieved successfully", ...user });
    return;
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "An unexpected error occurred",
      error: (error as Error).message,
    });
    return;
  }
};

export const createUserController = async (req: Request, res: Response) => {
  try {
    const changedBy = dataTokenPayload(req, res)?.id;
    const { firstName, phone, email, password, lastName, role, username, villageId } = req.body;
    const isPhoneExists = await isPhoneNumberTaken(phone);
    const hashedPassword = hashPassword(password);
    if (isPhoneExists) {
      return sendErrorResponse(
        res,
        StatusCodes.BAD_REQUEST,
        "ໝາຍເລກໂທລະສັບນີ້ ມີໃນລະບົບແລ້ວ",
      );
    }
    const transactionResult = await prisma.$transaction(async (tx) => {
      const newUser = buildNewUser({ firstName, lastName, phone, email, hashedPassword, role, username, villageId });
      const user = await createUserervice(newUser, tx);
      await createUserLogService({
        action: ActionType.CREATE,
        data: user,
        changedBy,
        tx,
      });
      return user;
    });
    return sendSuccessResponse(res, StatusCodes.CREATED, "ສ້າງບັນຊີສໍາເລັດ", { transactionResult });
  } catch (error) {
    logger.error(error);
    return sendErrorResponse(res, StatusCodes.INTERNAL_SERVER_ERROR, "ສ້າງບັນຊີບໍ່ສໍາເລັດ");
  } finally {
    await prisma.$disconnect();
  }
};

export const updateUserEditAccountController = async (
  req: Request,
  res: Response,
) => {
  const id = Number(req.params.id);
  try {
    const changedBy = dataTokenPayload(req, res)?.id;
    const transactionResult = await prisma.$transaction(async (tx) => {
      const data = await buildUserRecord(req.body);
      const existingCompany = await tx.user.findUnique({ where: { id } });
      const checkPhone = await findUserervice(data.phone, tx);
      if (checkPhone && checkPhone.id !== id) {
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
          status: "error",
          message: "ເບີໂທນີ້ ຖືກໃຊ້ງານແລ້ວ",
        });
        return;
      }
      const result = await updateUserAccountService({ data, id, tx });
      await createUserLogService({
        action: ActionType.UPDATE,
        data: existingCompany as Record<string, any>,
        changes: result as Record<string, any>,
        changedBy,
        tx,
      });
      return result;
    });
    res.json({
      status: "success",
      message: "edit success",
      data: transactionResult,
    });
    return;
  } catch (e) {
    logger.error(e);
    res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
      status: "error",
      message: "An unexpected error occurred",
    });
    return;
  } finally {
    await prisma.$disconnect();
  }
};

export const getAggregationUserController = async (
  req: Request,
  res: Response,
) => {
  try {
    const user = await getAggregationUserListServices();
    res.json({
      status: "ok",
      message: "success",
      ...user,
    });
    return;
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "An error occurred while fetching user aggregation.",
      error: error instanceof Error ? error.message : "Unknown error",
    });
  }
};
