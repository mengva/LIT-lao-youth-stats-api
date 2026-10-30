-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "Role" AS ENUM ('SUPER_ADMIN', 'PROVINCE_ADMIN', 'DISTRICT_ADMIN', 'VILLAGE_ADMIN');

-- CreateEnum
CREATE TYPE "ActionType" AS ENUM ('CREATE', 'UPDATE', 'DELETE', 'PATCH');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('DRAFT', 'SUBMITTED', 'VILLAGE_APPROVED', 'ZONE_APPROVED', 'ZONE_REJECTED', 'DISTRICT_APPROVED', 'DISTRICT_REJECTED', 'PROVINCE_APPROVED', 'PROVINCE_REJECTED', 'CENTRAL_APPROVED', 'CENTRAL_REJECTED', 'REGISTERED', 'REGISTERED_FAILED');

-- CreateEnum
CREATE TYPE "IdCardNumberStatus" AS ENUM ('PENDING_ISSUANCE', 'ISSUED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "PassportNumberStatus" AS ENUM ('PENDING_ISSUANCE', 'ISSUED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'PAID', 'FAILED', 'REFUNDED');

-- CreateTable
CREATE TABLE "users" (
    "id" SERIAL NOT NULL,
    "username" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "code" TEXT,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "english_name" TEXT,
    "gender" TEXT,
    "dob" TIMESTAMP(3),
    "id_card_number" TEXT,
    "id_card_number_expired_date" TIMESTAMP(3),
    "is_id_card_number_expired" BOOLEAN NOT NULL DEFAULT false,
    "id_card_number_status" "IdCardNumberStatus",
    "passport_number" TEXT,
    "passport_number_expired_date" TIMESTAMP(3),
    "is_passport_number_expired" BOOLEAN NOT NULL DEFAULT false,
    "passport_number_status" "PassportNumberStatus",
    "nationality" TEXT,
    "ethnic_group" TEXT,
    "religion" TEXT,
    "avatar_url" TEXT,
    "census" TEXT,
    "education_level" TEXT,
    "occupation" TEXT,
    "workplace" TEXT,
    "youth_join_date" TIMESTAMP(3),
    "youth_position" TEXT,
    "is_party_member" BOOLEAN NOT NULL DEFAULT false,
    "is_union_member" BOOLEAN NOT NULL DEFAULT false,
    "is_women_member" BOOLEAN NOT NULL DEFAULT false,
    "id_card_file_url" TEXT,
    "cv_file_url" TEXT,
    "role" "Role" NOT NULL DEFAULT 'SUPER_ADMIN',
    "status" "UserStatus" NOT NULL DEFAULT 'DRAFT',
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP,
    "villageid" INTEGER NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_log" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "action" "ActionType" NOT NULL,
    "changedBy" INTEGER NOT NULL,
    "changeDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "oldEmail" TEXT,
    "newEmail" TEXT,
    "oldPhone" TEXT,
    "newPhone" TEXT,
    "oldRole" "Role",
    "newRole" "Role",

    CONSTRAINT "user_log_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payments" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "amount" DECIMAL(12,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'LAK',
    "status" "PaymentStatus" NOT NULL DEFAULT 'PENDING',
    "payment_method" TEXT,
    "transaction_ref" TEXT,
    "paid_at" TIMESTAMP(3),
    "note" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "centrals" (
    "id" SERIAL NOT NULL,
    "name_la" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "centrals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "provinces" (
    "id" SERIAL NOT NULL,
    "central_id" INTEGER NOT NULL,
    "name_la" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "provinces_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "districts" (
    "id" SERIAL NOT NULL,
    "province_id" INTEGER NOT NULL,
    "name_la" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "districts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "zones" (
    "id" SERIAL NOT NULL,
    "district_id" INTEGER NOT NULL,
    "name_la" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "zones_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "villages" (
    "id" SERIAL NOT NULL,
    "district_id" INTEGER NOT NULL,
    "zone_id" INTEGER NOT NULL,
    "name_la" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "villages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "youth_statistics" (
    "id" SERIAL NOT NULL,
    "village_id" INTEGER NOT NULL,
    "period" TEXT NOT NULL,
    "non_member_male" INTEGER NOT NULL DEFAULT 0,
    "non_member_female" INTEGER NOT NULL DEFAULT 0,
    "total_member_male" INTEGER NOT NULL DEFAULT 0,
    "total_member_female" INTEGER NOT NULL DEFAULT 0,
    "student_male" INTEGER NOT NULL DEFAULT 0,
    "student_female" INTEGER NOT NULL DEFAULT 0,
    "university_male" INTEGER NOT NULL DEFAULT 0,
    "university_female" INTEGER NOT NULL DEFAULT 0,
    "civil_servant_male" INTEGER NOT NULL DEFAULT 0,
    "civil_servant_female" INTEGER NOT NULL DEFAULT 0,
    "public_male" INTEGER NOT NULL DEFAULT 0,
    "public_female" INTEGER NOT NULL DEFAULT 0,
    "party_member_male" INTEGER NOT NULL DEFAULT 0,
    "party_member_female" INTEGER NOT NULL DEFAULT 0,
    "union_male" INTEGER NOT NULL DEFAULT 0,
    "union_female" INTEGER NOT NULL DEFAULT 0,
    "disciplined_male" INTEGER NOT NULL DEFAULT 0,
    "disciplined_female" INTEGER NOT NULL DEFAULT 0,
    "over_age_male" INTEGER NOT NULL DEFAULT 0,
    "over_age_female" INTEGER NOT NULL DEFAULT 0,
    "resigned_male" INTEGER NOT NULL DEFAULT 0,
    "resigned_female" INTEGER NOT NULL DEFAULT 0,
    "new_joined_male" INTEGER NOT NULL DEFAULT 0,
    "new_joined_female" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "youth_statistics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "village_youth_secretaries" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "is_village_head" BOOLEAN NOT NULL DEFAULT false,
    "is_deputy_village_head" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "village_youth_secretaries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transfer_records" (
    "id" SERIAL NOT NULL,
    "section_type" TEXT NOT NULL,
    "full_name" TEXT NOT NULL,
    "new_position" TEXT NOT NULL,
    "previous_workplace" TEXT NOT NULL,
    "transferType" TEXT NOT NULL,
    "note" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "transfer_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "party_meeting_trackings" (
    "id" SERIAL NOT NULL,
    "office_level" TEXT NOT NULL,
    "total_staff" INTEGER NOT NULL DEFAULT 0,
    "female_staff" INTEGER NOT NULL DEFAULT 0,
    "secretary_in_party" BOOLEAN NOT NULL DEFAULT false,
    "note" TEXT,

    CONSTRAINT "party_meeting_trackings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "staff_profiles" (
    "id" SERIAL NOT NULL,
    "full_name" TEXT NOT NULL,
    "dob" TIMESTAMP(3),
    "state_join_date" TIMESTAMP(3),
    "gender" TEXT NOT NULL,
    "ethnicity" TEXT,
    "education_level" TEXT,
    "major" TEXT,
    "party_join_date" TIMESTAMP(3),
    "youth_join_date" TIMESTAMP(3),
    "union_join_date" TIMESTAMP(3),
    "position" TEXT,
    "theory_level" TEXT,
    "languages" TEXT,
    "phone" TEXT,
    "staff_category" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "staff_profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "executive_committees" (
    "id" SERIAL NOT NULL,
    "full_name" TEXT NOT NULL,
    "age" INTEGER,
    "ethnicity" TEXT,
    "birth_date" TIMESTAMP(3),
    "state_join_date" TIMESTAMP(3),
    "state_position" TEXT,
    "party_position" TEXT,
    "youth_position" TEXT,
    "workplace" TEXT,
    "education_level" TEXT,
    "theory_level" TEXT,
    "phone" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "executive_committees_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "secretariat_coordinators" (
    "id" SERIAL NOT NULL,
    "province_name" TEXT NOT NULL,
    "full_name" TEXT NOT NULL,
    "gender" TEXT NOT NULL,
    "party_position" TEXT,
    "state_position" TEXT,
    "office_phone" TEXT,
    "whatsapp" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "secretariat_coordinators_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organizational_structures" (
    "id" SERIAL NOT NULL,
    "province_name" TEXT NOT NULL,
    "district_name" TEXT,
    "province_dept_count" INTEGER NOT NULL DEFAULT 0,
    "province_staff_count" INTEGER NOT NULL DEFAULT 0,
    "missing_province_dept" TEXT,
    "district_unit_count" INTEGER NOT NULL DEFAULT 0,
    "district_staff_count" INTEGER NOT NULL DEFAULT 0,
    "missing_district_unit" TEXT,
    "note" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "organizational_structures_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_key" ON "users"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "users_code_key" ON "users"("code");

-- CreateIndex
CREATE UNIQUE INDEX "users_id_card_number_key" ON "users"("id_card_number");

-- CreateIndex
CREATE UNIQUE INDEX "users_passport_number_key" ON "users"("passport_number");

-- CreateIndex
CREATE INDEX "users_role_idx" ON "users"("role");

-- CreateIndex
CREATE INDEX "users_is_active_idx" ON "users"("is_active");

-- CreateIndex
CREATE INDEX "users_villageid_idx" ON "users"("villageid");

-- CreateIndex
CREATE INDEX "users_status_idx" ON "users"("status");

-- CreateIndex
CREATE INDEX "user_log_userId_idx" ON "user_log"("userId");

-- CreateIndex
CREATE INDEX "payments_user_id_idx" ON "payments"("user_id");

-- CreateIndex
CREATE INDEX "payments_status_idx" ON "payments"("status");

-- CreateIndex
CREATE UNIQUE INDEX "centrals_code_key" ON "centrals"("code");

-- CreateIndex
CREATE INDEX "centrals_code_idx" ON "centrals"("code");

-- CreateIndex
CREATE INDEX "centrals_createdAt_idx" ON "centrals"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "provinces_code_key" ON "provinces"("code");

-- CreateIndex
CREATE INDEX "provinces_central_id_idx" ON "provinces"("central_id");

-- CreateIndex
CREATE INDEX "districts_province_id_idx" ON "districts"("province_id");

-- CreateIndex
CREATE INDEX "districts_code_idx" ON "districts"("code");

-- CreateIndex
CREATE INDEX "districts_createdAt_idx" ON "districts"("createdAt");

-- CreateIndex
CREATE INDEX "zones_district_id_idx" ON "zones"("district_id");

-- CreateIndex
CREATE INDEX "zones_code_idx" ON "zones"("code");

-- CreateIndex
CREATE INDEX "villages_district_id_idx" ON "villages"("district_id");

-- CreateIndex
CREATE INDEX "villages_zone_id_idx" ON "villages"("zone_id");

-- CreateIndex
CREATE INDEX "villages_code_idx" ON "villages"("code");

-- CreateIndex
CREATE INDEX "villages_createdAt_idx" ON "villages"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "village_youth_secretaries_user_id_key" ON "village_youth_secretaries"("user_id");

-- CreateIndex
CREATE INDEX "village_youth_secretaries_user_id_idx" ON "village_youth_secretaries"("user_id");

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_villageid_fkey" FOREIGN KEY ("villageid") REFERENCES "villages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_log" ADD CONSTRAINT "user_log_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provinces" ADD CONSTRAINT "provinces_central_id_fkey" FOREIGN KEY ("central_id") REFERENCES "centrals"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "districts" ADD CONSTRAINT "districts_province_id_fkey" FOREIGN KEY ("province_id") REFERENCES "provinces"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "zones" ADD CONSTRAINT "zones_district_id_fkey" FOREIGN KEY ("district_id") REFERENCES "districts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "villages" ADD CONSTRAINT "villages_district_id_fkey" FOREIGN KEY ("district_id") REFERENCES "districts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "villages" ADD CONSTRAINT "villages_zone_id_fkey" FOREIGN KEY ("zone_id") REFERENCES "zones"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "youth_statistics" ADD CONSTRAINT "youth_statistics_village_id_fkey" FOREIGN KEY ("village_id") REFERENCES "villages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "village_youth_secretaries" ADD CONSTRAINT "village_youth_secretaries_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

