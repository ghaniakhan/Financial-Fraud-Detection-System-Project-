using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.StartPanel;
using System.Windows.Forms;

namespace WindowsFormsApp3
{
    public class Validity
    {
        public static bool IsAlpha(string input)
        {
            return Regex.IsMatch(input, "^[a-zA-Z]+$");
        }
        public static bool IsAlphaLast(string input)
        {
            // Allow an empty string or a string containing only alphabetical characters
            return string.IsNullOrEmpty(input) || Regex.IsMatch(input, "^[a-zA-Z]+$");
        }

        // Function to check if a string is a valid email format
        public static bool IsEmailValid(string email)
        {
            return Regex.IsMatch(email, @"^[a-zA-Z0-9._%+-]+@(gmail\.com|outlook\.com)$");
        }

        public static bool IsValidPhoneNumber(string phoneNumber)
        {
            // Define the regex pattern for the phone number
            string pattern = @"^\+\d{2}\s\d{10}$";

            // Use Regex.IsMatch to check if the phone number matches the pattern
            return Regex.IsMatch(phoneNumber, pattern);
        }

        public static bool IsValidUsername(string username)
        {
            int minUsernameLength = 6;
            int maxUsernameLength = 10;
            if (string.IsNullOrEmpty(username))
            {
                MessageBox.Show("Username cannot be empty.");
                return true;
            }
            if (username.Length < minUsernameLength || username.Length > maxUsernameLength)
            {
                MessageBox.Show("Username length should be between " + minUsernameLength + " and " + maxUsernameLength + " characters.");
                return true;
            }
            if (!Regex.IsMatch(username, @"^[a-zA-Z0-9_]+$"))
            {
                MessageBox.Show("Username should contain only alphanumeric characters and underscores.");
                return true;
            }
            else return false;
        }
        public static bool IsValidPassword(string password)
        {
            int minPasswordLength = 8;
            int maxPasswordLength = 15;
            if (string.IsNullOrEmpty(password))
            {
                MessageBox.Show("Password cannot be empty.");
                return true;
            }
            if (password.Length < minPasswordLength || password.Length > maxPasswordLength)
            {
                MessageBox.Show("Password length should be between " + minPasswordLength + " and " + maxPasswordLength + " characters.");
                return true;
            }
            if (!Regex.IsMatch(password, @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$"))
            {
                MessageBox.Show("Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character.");
                return true;
            }
            else
            {
                return false;
            }
        }
        public static bool IsValidBankName(string bankName)
        {
            if (string.IsNullOrEmpty(bankName))
            {
                MessageBox.Show("Bank name cannot be empty.");
                return false;
            }

            // Check if bank name contains only alphabets
            if (!Regex.IsMatch(bankName, @"^[a-zA-Z]+$"))
            {
                MessageBox.Show("Bank name should contain only alphabets.");
                return false;
            }

            // If all validations pass, return true
            return true;
        }
        public static bool IsValidChequeNumber(string chequeNumber)
        {


            // Check if cheque number contains only digits
            if (!Regex.IsMatch(chequeNumber, @"^\d+$"))
            {
                MessageBox.Show("Cheque number should contain only digits.");
                return false;
            }

            // If all validations pass, return true
            return true;
        }

        public static bool IsValidAccountNumber(string accountNumber)
        {


            // Check if account number contains only digits
            if (!Regex.IsMatch(accountNumber, @"^\d+$"))
            {
                MessageBox.Show("Account number should contain only digits.");
                return false;
            }

            // If all validations pass, return true
            return true;
        }
        public static bool IsValidCardNumber(string cardNumber)
        {
            if (!Regex.IsMatch(cardNumber, @"^\d+$"))
            {
                MessageBox.Show("Card number should contain only digits.");
                return false;
            }
            return true;
        } 
    }
}
