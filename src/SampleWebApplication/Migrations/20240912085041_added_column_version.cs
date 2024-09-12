using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SampleWebApplication.Migrations
{
    /// <inheritdoc />
    public partial class added_column_version : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Version",
                table: "ApplicationConfigurations",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Version",
                table: "ApplicationConfigurations");
        }
    }
}
