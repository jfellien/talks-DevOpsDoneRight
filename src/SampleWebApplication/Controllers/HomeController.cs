using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using SampleWebApplication.Models;
using SampleWebApplication.Services;

namespace SampleWebApplication.Controllers;

public class HomeController(
    ISampleRepository sampleRepository,
    ILogger<HomeController> logger) : Controller
{
    
    public IActionResult Index()
    {
        string environment = sampleRepository.GetEnvironment();
        
        return View(new IndexViewModel{ Environment = environment });
    }

    public IActionResult Privacy()
    {
        return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}