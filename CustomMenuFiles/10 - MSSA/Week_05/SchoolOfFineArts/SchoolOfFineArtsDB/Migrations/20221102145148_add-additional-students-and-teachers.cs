using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SchoolOfFineArtsDB.Migrations
{
    public partial class addadditionalstudentsandteachers : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Students",
                columns: new[] { "Id", "DateOfBirth", "FirstName", "LastName" },
                values: new object[,]
                {
                    { 6, new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "David", "Diaz Morales" },
                    { 7, new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Andrew", "Nelson" },
                    { 8, new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Brian", "Braine" },
                    { 9, new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Donovan", "Zeanah" },
                    { 10, new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Jackson", "Freiburg" },
                    { 11, new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Joshua", "Benson" },
                    { 12, new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Mursal", "Qaderyan" },
                    { 13, new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Rohin", "Qaderyan" },
                    { 14, new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Rico", "Rodriguez" },
                    { 15, new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Tom", "Brady" },
                    { 16, new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Aaron", "Rogers" },
                    { 17, new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Dax", "Prescott" },
                    { 18, new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Joe", "Burrow" },
                    { 19, new DateTime(1984, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Trevor", "Lawrence" }
                });

            migrationBuilder.UpdateData(
                table: "Teachers",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "Age", "FirstName", "LastName" },
                values: new object[] { 64, "Tom", "Hanks" });

            migrationBuilder.InsertData(
                table: "Teachers",
                columns: new[] { "Id", "Age", "FirstName", "LastName" },
                values: new object[,]
                {
                    { 6, 62, "Tom", "Cruise" },
                    { 7, 57, "Val", "Kilmer" },
                    { 8, 48, "Geena", "Davis" },
                    { 9, 37, "Chris", "Pratt" },
                    { 10, 42, "Anne", "Hathaway" }
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Students",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Students",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Students",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Students",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Students",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Students",
                keyColumn: "Id",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Students",
                keyColumn: "Id",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Students",
                keyColumn: "Id",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "Students",
                keyColumn: "Id",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Students",
                keyColumn: "Id",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "Students",
                keyColumn: "Id",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "Students",
                keyColumn: "Id",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "Students",
                keyColumn: "Id",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "Students",
                keyColumn: "Id",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "Teachers",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Teachers",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Teachers",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Teachers",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Teachers",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.UpdateData(
                table: "Teachers",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "Age", "FirstName", "LastName" },
                values: new object[] { 62, "Jaime", "Escalante" });
        }
    }
}
