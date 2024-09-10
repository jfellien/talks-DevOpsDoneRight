using Microsoft.EntityFrameworkCore;

namespace SampleWebApplication.Services;

public class SampleDbContext(DbContextOptions<SampleDbContext> options) : DbContext(options)
{
    
    public DbSet<ApplicationConfiguration> ApplicationConfigurations { get; set; }
}