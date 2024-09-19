namespace SampleWebApplication.Services;

public interface ISampleRepository
{
    string GetEnvironment();
    string GetEnvironmentVersion();
    string GetLocation();
}