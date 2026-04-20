namespace MathToolsApp;

public partial class MainPage : ContentPage
{
    public MainPage()
    {
        InitializeComponent();
        
        AlgebraBtn.Clicked += OnAlgebraClicked;
        CalculusBtn.Clicked += OnCalculusClicked;
        StatsBtn.Clicked += OnStatsClicked;
        ConverterBtn.Clicked += OnConverterClicked;
        MatrixBtn.Clicked += OnMatrixClicked;
    }
    
    private async void OnAlgebraClicked(object? sender, EventArgs e)
    {
        string input = await DisplayPromptAsync("Algebra Solver", 
            "Enter a, b, c for ax² + bx + c = 0\nExample: 1 -5 6",
            placeholder: "a b c", keyboard: Keyboard.Numeric);
            
        if (!string.IsNullOrEmpty(input))
        {
            var parts = input.Split(' ');
            if (parts.Length == 3 && 
                double.TryParse(parts[0], out double a) &&
                double.TryParse(parts[1], out double b) &&
                double.TryParse(parts[2], out double c))
            {
                if (a == 0)
                {
                    await DisplayAlert("Error", "a cannot be zero", "OK");
                    return;
                }
                
                double discriminant = b * b - 4 * a * c;
                
                if (discriminant < 0)
                {
                    await DisplayAlert("Result", "No real solutions", "OK");
                }
                else if (discriminant == 0)
                {
                    double x = -b / (2 * a);
                    await DisplayAlert("Result", $"One solution: x = {x:F2}", "OK");
                }
                else
                {
                    double x1 = (-b + Math.Sqrt(discriminant)) / (2 * a);
                    double x2 = (-b - Math.Sqrt(discriminant)) / (2 * a);
                    await DisplayAlert("Result", $"x₁ = {x1:F2}\nx₂ = {x2:F2}", "OK");
                }
            }
            else
            {
                await DisplayAlert("Error", "Please enter 3 numbers", "OK");
            }
        }
    }
    
    private async void OnCalculusClicked(object? sender, EventArgs e)
    {
        string input = await DisplayPromptAsync("Derivative Calculator", 
            "Enter x value:",
            placeholder: "Example: 2", keyboard: Keyboard.Numeric);
            
        if (!string.IsNullOrEmpty(input) && double.TryParse(input, out double x))
        {
            double derivative = 2 * x;
            await DisplayAlert("Derivative", $"f(x) = x²\nf'({x}) = {derivative:F2}", "OK");
        }
    }
    
    private async void OnStatsClicked(object? sender, EventArgs e)
    {
        string input = await DisplayPromptAsync("Statistics", 
            "Enter numbers separated by commas:",
            placeholder: "Example: 2,4,6,8,10");
            
        if (!string.IsNullOrEmpty(input))
        {
            try
            {
                var numbers = input.Split(',')
                    .Select(n => double.Parse(n.Trim()))
                    .ToArray();
                
                double mean = numbers.Average();
                var sorted = numbers.OrderBy(x => x).ToArray();
                double median = sorted.Length % 2 == 0 ? 
                    (sorted[sorted.Length / 2 - 1] + sorted[sorted.Length / 2]) / 2 : 
                    sorted[sorted.Length / 2];
                double sumSquaredDiff = numbers.Sum(x => Math.Pow(x - mean, 2));
                double stdDev = Math.Sqrt(sumSquaredDiff / numbers.Length);
                
                await DisplayAlert("Statistics Results",
                    $"Mean: {mean:F2}\nMedian: {median:F2}\nStd Dev: {stdDev:F2}\nCount: {numbers.Length}",
                    "OK");
            }
            catch
            {
                await DisplayAlert("Error", "Use comma-separated numbers like: 2,4,6", "OK");
            }
        }
    }
    
    private async void OnConverterClicked(object? sender, EventArgs e)
    {
        string[] categories = { "Length", "Weight", "Temperature" };
        string category = await DisplayActionSheet("Select Category", "Cancel", null, categories);
        
        if (category != "Cancel")
        {
            string[] units = category switch
            {
                "Length" => new[] { "Meters", "Kilometers", "Miles", "Feet" },
                "Weight" => new[] { "Kilograms", "Grams", "Pounds", "Ounces" },
                "Temperature" => new[] { "Celsius", "Fahrenheit", "Kelvin" },
                _ => new[] { "" }
            };
            
            string fromUnit = await DisplayActionSheet("From Unit", "Cancel", null, units);
            if (fromUnit != "Cancel")
            {
                string toUnit = await DisplayActionSheet("To Unit", "Cancel", null, units);
                if (toUnit != "Cancel")
                {
                    string valueInput = await DisplayPromptAsync("Convert", 
                        $"Enter value in {fromUnit}:",
                        keyboard: Keyboard.Numeric);
                        
                    if (!string.IsNullOrEmpty(valueInput) && double.TryParse(valueInput, out double value))
                    {
                        double result = 0;
                        
                        if (category == "Length")
                        {
                            double inMeters = fromUnit switch
                            {
                                "Meters" => value,
                                "Kilometers" => value * 1000,
                                "Miles" => value * 1609.34,
                                "Feet" => value * 0.3048,
                                _ => value
                            };
                            result = toUnit switch
                            {
                                "Meters" => inMeters,
                                "Kilometers" => inMeters / 1000,
                                "Miles" => inMeters / 1609.34,
                                "Feet" => inMeters / 0.3048,
                                _ => inMeters
                            };
                        }
                        else if (category == "Weight")
                        {
                            double inKg = fromUnit switch
                            {
                                "Kilograms" => value,
                                "Grams" => value / 1000,
                                "Pounds" => value * 0.453592,
                                "Ounces" => value * 0.0283495,
                                _ => value
                            };
                            result = toUnit switch
                            {
                                "Kilograms" => inKg,
                                "Grams" => inKg * 1000,
                                "Pounds" => inKg / 0.453592,
                                "Ounces" => inKg / 0.0283495,
                                _ => inKg
                            };
                        }
                        else if (category == "Temperature")
                        {
                            double inCelsius = fromUnit switch
                            {
                                "Celsius" => value,
                                "Fahrenheit" => (value - 32) * 5 / 9,
                                "Kelvin" => value - 273.15,
                                _ => value
                            };
                            result = toUnit switch
                            {
                                "Celsius" => inCelsius,
                                "Fahrenheit" => inCelsius * 9 / 5 + 32,
                                "Kelvin" => inCelsius + 273.15,
                                _ => inCelsius
                            };
                        }
                        
                        await DisplayAlert("Result", $"{value} {fromUnit} = {result:F4} {toUnit}", "OK");
                    }
                }
            }
        }
    }
    
    private async void OnMatrixClicked(object? sender, EventArgs e)
    {
        string input = await DisplayPromptAsync("2x2 Matrix Determinant", 
            "Enter values a b c d for matrix:\n| a b |\n| c d |\n\nExample: 1 2 3 4",
            placeholder: "a b c d", keyboard: Keyboard.Numeric);
            
        if (!string.IsNullOrEmpty(input))
        {
            var parts = input.Split(' ');
            if (parts.Length == 4 &&
                double.TryParse(parts[0], out double a) &&
                double.TryParse(parts[1], out double b) &&
                double.TryParse(parts[2], out double c) &&
                double.TryParse(parts[3], out double d))
            {
                double det = a * d - b * c;
                await DisplayAlert("Matrix Result",
                    $"| {a:F2}  {b:F2} |\n| {c:F2}  {d:F2} |\n\nDeterminant = {det:F4}\n\nInverse exists: {(det != 0 ? "Yes" : "No")}", 
                    "OK");
            }
            else
            {
                await DisplayAlert("Error", "Please enter 4 numbers separated by spaces", "OK");
            }
        }
    }
}