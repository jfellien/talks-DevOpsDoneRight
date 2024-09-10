namespace SampleWebApplication.Services;


internal class SampleRepository(
    SampleDbContext dbContext) : ISampleRepository
{

    public string GetEnvironment()
    {
        ApplicationConfiguration? environmentSetting = dbContext.ApplicationConfigurations
            .SingleOrDefault(x => x.Name == "Environment");

        return environmentSetting is null 
            ? "Unknown" 
            : environmentSetting.Value;
    }
}