namespace MyAndroidApp;

public partial class MainPage : ContentPage
{
    int count = 0;
    
    public MainPage()
    {
        InitializeComponent();
    }
    
    private void OnButtonClicked(object sender, EventArgs e)
    {
        count++;
        lblCounter.Text = count == 1 ? $"{count} click" : $"{count} clicks";
        lblMessage.Text = count == 1 ? "Great start!" : "Keep going!";
    }
}