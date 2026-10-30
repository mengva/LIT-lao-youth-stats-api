import { PrismaClient } from "@prisma/client";
import extension from "../utils/extension";

extension;

export const prisma = new PrismaClient({});

