using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using SampleWebApplication.Services;

namespace SampleWebApplication;

public class SampleDbContextFactory : IDesignTimeDbContextFactory<SampleDbContext>
{
    public SampleDbContext CreateDbContext(string[] args)
    {
        DbContextOptionsBuilder<SampleDbContext> optionsBuilder = new ();

        optionsBuilder.UseInMemoryDatabase("SampleDB");

        return new SampleDbContext(optionsBuilder.Options);
    }
}