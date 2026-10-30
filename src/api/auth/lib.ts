import bcrypt from "bcrypt";
import { findOneUserervice } from "../../api/user/service";
import { BuildPayload } from "./types";

export const getUserByPhone = async (username: string) => {
  return await findOneUserervice(username);
};

export const validatePassword = (
  plainPassword: string,
  hashedPassword: string,
): boolean => {
  return bcrypt.compareSync(plainPassword, hashedPassword);
};

export const buildPayload = (user: any) => ({
  id: user.id,
  phone: user.phone,
  role: user.role,
  firstName: user.firstName,
  email: user.email,
  lastName: user.lastName,
  username: user.username,
} as BuildPayload);
