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

    public string GetEnvironmentVersion()
    {
        ApplicationConfiguration? environmentSetting = dbContext.ApplicationConfigurations
            .SingleOrDefault(x => x.Name == "Environment");

        return environmentSetting is null 
            ? "0.0" 
            : environmentSetting.Version;
    }

    public string GetLocation()
    {
        ApplicationConfiguration? environmentSetting = dbContext.ApplicationConfigurations
            .SingleOrDefault(x => x.Name == "Environment");
        
        return environmentSetting is null 
            ? "Unbekannt" 
            : environmentSetting.Location;
        
    }
}