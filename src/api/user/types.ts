import { Role } from "@prisma/client";

export interface TokenPayload {
  phone: string;
  id: number;
  role: string;
  firstName: string;
  lastName: string;
  username?: string;
}

export enum Roles {
  ADMIN = "ADMIN",
  STAFF = "STAFF",
}

export interface UserRecord {
  firstName: string;
  lastName: string;
  phone: string;
  email: string;
  password?: string;
  username?: string;
  role: Role;
  isActive?: boolean;
}
