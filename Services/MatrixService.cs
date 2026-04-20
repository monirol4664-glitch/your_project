namespace MathToolsApp.Services;

public class MatrixService
{
    public double Determinant(double[,] matrix)
    {
        if (matrix.GetLength(0) == 2)
            return matrix[0, 0] * matrix[1, 1] - matrix[0, 1] * matrix[1, 0];
        return 0;
    }
}