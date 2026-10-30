import { Router } from "express";
import { authenticate } from "../../utils/jwt";
import { valResult } from "../../utils/validateResult";

import { userSchemaCreate } from "./validate";

import {
  createUserController,
  getAggregationUserController,
  getManyUserController,
  getOneUserController,
  updateUserEditAccountController,
} from "./controller";
import { roleAccess } from "../../middleware/role/roleAccress";
import { Roles } from "../../api/user/types";

const router = Router();

router.get("/user", authenticate, getManyUserController);
router.get("/user/:id", authenticate, roleAccess([Roles.ADMIN]), getOneUserController);
router.post("/user", authenticate, roleAccess([Roles.ADMIN]), userSchemaCreate, valResult, createUserController);
router.put("/user/:id", authenticate, roleAccess([Roles.ADMIN]), authenticate, valResult, updateUserEditAccountController);
router.get("/user-aggregation", authenticate, roleAccess([Roles.ADMIN]), getAggregationUserController);

export default router;
