using AzureMaps.Data;
using AzureMaps.Service;
using AzureMapsControl.Components;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();
builder.Services.AddSingleton<WeatherForecastService>();

builder.Services
    .AddScoped<Darnton.Blazor.DeviceInterop.Geolocation.IGeolocationService, 
    Darnton.Blazor.DeviceInterop.Geolocation.GeolocationService>();

var AzureMaps = builder.Configuration.GetSection("AzureMaps");

//This code uses an anonymous authentication
builder.Services.AddAzureMapsControl(
    configuration => configuration.ClientId = AzureMaps.GetValue<string>("ClientId"));

var app = builder.Build();

AuthService.SetAuthSettings(AzureMaps);

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseStaticFiles();

app.UseRouting();

app.MapBlazorHub();
app.MapFallbackToPage("/_Host");

app.Run();
