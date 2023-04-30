using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ContactWebEFCore6.Data.Migrations
{
    public partial class customizedcontactwebuseraddedpassphrase : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "PasswordPhrase",
                table: "AspNetUsers",
                type: "nvarchar(255)",
                maxLength: 255,
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PasswordPhrase",
                table: "AspNetUsers");
        }
    }
}
