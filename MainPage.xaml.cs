using MathToolsApp.Views;

namespace MathToolsApp;

public partial class MainPage : ContentPage
{
    public MainPage()
    {
        InitializeComponent();
        
        ToolsCollection.ItemsSource = new[]
        {
            new { Icon = "📐", Name = "Algebra Solver", Description = "Linear, quadratic, systems" },
            new { Icon = "📈", Name = "Graphing", Description = "2D function plots" },
            new { Icon = "🔢", Name = "Matrix Calc", Description = "Add, multiply, inverse" },
            new { Icon = "∫", Name = "Calculus", Description = "Derivatives, integrals" },
            new { Icon = "📊", Name = "Statistics", Description = "Mean, regression, variance" },
            new { Icon = "🔄", Name = "Converter", Description = "Units, currencies" },
            new { Icon = "🔬", Name = "Fractions", Description = "Simplify, compare" },
            new { Icon = "🔢", Name = "Prime Tools", Description = "Factor, check, generate" },
            new { Icon = "📐", Name = "Geometry", Description = "Area, volume, theorems" },
            new { Icon = "💻", Name = "Base Converter", Description = "Binary, hex, decimal" }
        };
        
        ToolsCollection.SelectionChanged += OnToolSelected;
    }
    
    private async void OnToolSelected(object sender, SelectionChangedEventArgs e)
    {
        var selected = e.CurrentSelection.FirstOrDefault() as dynamic;
        if (selected == null) return;
        
        Page page = selected.Name switch
        {
            "Algebra Solver" => new AlgebraPage(),
            "Matrix Calc" => new MatrixPage(),
            "Calculus" => new CalculusPage(),
            "Statistics" => new StatisticsPage(),
            "Converter" => new ConverterPage(),
            _ => null
        };
        
        if (page != null)
            await Navigation.PushAsync(page);
    }
}