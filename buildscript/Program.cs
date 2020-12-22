using System;

namespace buildscript
{
    internal static class Program
    {
        private const string DotnetRunningInContainer = "DOTNET_RUNNING_IN_CONTAINER";
        private const string DotnetVersion = "DOTNET_VERSION";
        private const string ImageRevision = "org.opencontainers.image.revision";
        private const string ImageCreated = "org.opencontainers.image.created";
        private const string ImageVersion = "org.opencontainers.image.version";

        private static void Main()
        {
            Console.WriteLine("Build Script test application");
            var env = Environment.GetEnvironmentVariables();

            var inContainer = env.Contains(DotnetRunningInContainer)
                && string.Equals(env[DotnetRunningInContainer].ToString(),
                    "TRUE",
                    StringComparison.InvariantCultureIgnoreCase);

            if (inContainer)
            {
                var version = env[DotnetVersion] ?? "unknown";
                Console.WriteLine($"Running in a container, .NET Version {version}");

                if (env.Contains(ImageCreated))
                {
                    Console.WriteLine($"Image Created from environment: {env[ImageCreated]}");
                }

                if (env.Contains(ImageRevision))
                {
                    Console.WriteLine($"Image Revision from environment: {env[ImageRevision]}");
                }

                if (env.Contains(ImageVersion))
                {
                    Console.WriteLine($"Image Version from environment: {env[ImageVersion]}");
                }
            }
            else
            {
                Console.WriteLine("Not running in a container.");
            }
        }
    }
}
