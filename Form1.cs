using CrystalDecisions.CrystalReports.Engine;
using Microsoft.PowerBI.Api;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Windows.Forms.DataVisualization.Charting;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace WindowsFormsApp3
{
    public partial class Form1 : Form
    {
        ContextMenuStrip alertMenu = new ContextMenuStrip();
        public static int AuditorID { get; private set; }
        public static int partnerid { get; private set; }
        public int maxInstallments;
        public int installmentPlanID;
        public int transactionId;

        public static int AuditID { get; private set; }
        public Form1()
        {
            InitializeComponent();
            tabControl1.SelectedTab = tabPage6;

            tabControl1.ItemSize = new Size(0, 1);
            foreach (TabPage tabPage in tabControl1.TabPages)
            {
                tabPage.Text = string.Empty;
            }
            tabControl1.Appearance = TabAppearance.FlatButtons;
            tabControl2.ItemSize = new Size(0, 1);
            foreach (TabPage tabPage in tabControl2.TabPages)
            {
                tabPage.Text = string.Empty;
            }
            tabControl3.Appearance = TabAppearance.FlatButtons;
            tabControl3.ItemSize = new Size(0, 1);
            foreach (TabPage tabPage in tabControl3.TabPages)
            {
                tabPage.Text = string.Empty;
            }
            tabControl3.Appearance = TabAppearance.FlatButtons;
            tabControl4.ItemSize = new Size(0, 1);
            foreach (TabPage tabPage in tabControl4.TabPages)
            {
                tabPage.Text = string.Empty;
            }
            tabControl4.Appearance = TabAppearance.FlatButtons;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            string selectedAuditType = comboBox1.SelectedItem.ToString();
            if (selectedAuditType == null)
            {
                MessageBox.Show("Please select an audit type.");
                return;
            }
            string auditstatus = "Undergoing";
            int auditorID = AuditorID;
            if (auditorID == 0)
            {
                MessageBox.Show("Auditor ID not found.");
                return;
            }
            var con = Configuration.getInstance().getConnection();
            SqlCommand command = new SqlCommand("INSERT INTO Audit (Timestamp, AuditorID , AuditType, AuditStatus) VALUES (@Timestamp , @AuditorID, @AuditType, @AuditStatus) SELECT SCOPE_IDENTITY();", con);
            command.Parameters.AddWithValue("@Timestamp ", DateTime.Now);
            command.Parameters.AddWithValue("@AuditType", selectedAuditType);
            command.Parameters.AddWithValue("@AuditStatus", auditstatus);
            command.Parameters.AddWithValue("@AuditorID", auditorID);
            AuditID = Convert.ToInt32(command.ExecuteScalar());
            int rowAffected = command.ExecuteNonQuery();
            if (rowAffected > 0)
            {
                MessageBox.Show("Audit information saved successfully!");

                int selectedMonth = dateTimePicker2.Value.Month;
                int selectedYear = dateTimePicker2.Value.Year;
                DateTime startDate = new DateTime(selectedYear, selectedMonth, 1);
                DateTime endDate = startDate.AddMonths(1).AddDays(-1);
                string query = @"
    SELECT 
        t.TransactionID,
        t.TransactionType,
        t.Amount,
        t.Date AS TransactionDate,
        CASE
            WHEN cc.CreditCardID IS NOT NULL THEN 'Credit Card'
            WHEN ch.ChequeID IS NOT NULL THEN 'Cheque'
            ELSE 'Online' -- You can change this to handle other cases
        END AS [PaymentType],
        i.InstallmentPlanID
    FROM 
        Transactions t
    LEFT JOIN 
        PaymentMethod pm ON t.PaymentMethodID = pm.PaymentMethodID
    LEFT JOIN 
        CreditCard cc ON pm.CreditCardID = cc.CreditCardID
    LEFT JOIN 
        Cheque ch ON pm.ChequeID = ch.ChequeID
    LEFT JOIN 
        InstallmentPlan i ON t.InstallmentPlanID = i.InstallmentPlanID
    WHERE 
        pm.PaymentType IS NOT NULL
        AND t.Date >= @StartDate
        AND t.Date <= @EndDate;";

                var cons = Configuration.getInstance().getConnection();
                SqlCommand commands = new SqlCommand(query, cons);
                commands.Parameters.AddWithValue("@StartDate", startDate);
                commands.Parameters.AddWithValue("@EndDate", endDate);
                tabControl2.SelectedTab = tabPage9;
                SqlDataAdapter adapter = new SqlDataAdapter(commands);
                DataTable dataTable = new DataTable();
                adapter.Fill(dataTable);
                dataGridView1.DataSource = dataTable;
                dataGridView1.Columns["TransactionID"].HeaderText = "Transaction ID";
                dataGridView1.Columns["TransactionType"].HeaderText = "Transaction Type";
                dataGridView1.Columns["Amount"].HeaderText = "Amount";
                dataGridView1.Columns["TransactionDate"].HeaderText = "Transaction Date";
                dataGridView1.Columns["PaymentType"].HeaderText = "Payment Type";
                dataGridView1.Columns["InstallmentPlanID"].Visible = true;
                dataGridView1.CellFormatting += DataGridView1_CellFormatting;
                dataGridView1.CellContentClick += DataGridView1_CellContentClick;

            }
        }
        private void DataGridView1_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            if (dataGridView1.Columns[e.ColumnIndex].Name == "PaymentType" && e.RowIndex >= 0)
            {
                e.CellStyle.BackColor = Color.SteelBlue;
                e.CellStyle.ForeColor = Color.White;
                e.CellStyle.SelectionBackColor = Color.DarkBlue;
                e.CellStyle.SelectionForeColor = Color.White;

            }
            if (dataGridView1.Columns[e.ColumnIndex].Name == "InstallmentPlanID" && e.RowIndex >= 0)
            {
                e.CellStyle.BackColor = Color.SteelBlue;
                e.CellStyle.ForeColor = Color.White;
                e.CellStyle.SelectionBackColor = Color.DarkBlue;
                e.CellStyle.SelectionForeColor = Color.White;
            }
        }

        private void DataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0 && e.ColumnIndex >= 0 && dataGridView1.Columns[e.ColumnIndex].Name == "PaymentType")
            {
                string paymentType = dataGridView1.Rows[e.RowIndex].Cells["PaymentType"].Value.ToString();

                if (paymentType.Equals("Credit Card", StringComparison.OrdinalIgnoreCase))
                {
                    dataGridView2.Visible = true;
                    btnBackk.Visible = true;
                    button5.Visible = false;
                    PopulateDataGridView2(e.RowIndex);
                }
                else
                if (paymentType.Equals("Cheque", StringComparison.OrdinalIgnoreCase))
                {
                    dataGridView3.Visible = true;
                    btnBackk.Visible = true;
                    button5.Visible = false;
                    PopulateDataGridView3(e.RowIndex);
                }
                else
                if (paymentType.Equals("Online", StringComparison.OrdinalIgnoreCase))
                {
                    dataGridView5.Visible = true;
                    btnBackk.Visible = true;
                    button5.Visible = false;

                    PopulateDataGridView5(e.RowIndex);
                }

            }

            if (e.RowIndex >= 0 && e.ColumnIndex >= 0 && dataGridView1.Columns[e.ColumnIndex].Name == "InstallmentPlanID")
            {
                int installmentPlanID = Convert.ToInt32(dataGridView1.Rows[e.RowIndex].Cells["InstallmentPlanID"].Value);
                dataGridView4.Visible = true;
                btnBackk.Visible = true;
                button5.Visible = false;
                PopulateDataGridView4(installmentPlanID);
            }
        }
        public void PopulateDataGridView4(int installmentPlanID)
        {
            string query = "SELECT * FROM Installments WHERE InstallmentPlanID = @InstallmentPlanID";
            var con = Configuration.getInstance().getConnection();
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@InstallmentPlanID", installmentPlanID);
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);
            dataGridView4.DataSource = dataTable;

        }

        public void PopulateDataGridView5(int rowIndex)
        {
            string transactionID = dataGridView1.Rows[rowIndex].Cells["TransactionID"].Value.ToString();
            string query = "SELECT cc.* FROM Onlines cc  INNER JOIN PaymentMethod pm ON cc.OnlineID = pm.OnlineID  INNER JOIN Transactions t ON pm.PaymentMethodID = t.PaymentMethodID  WHERE t.TransactionID = @TransactionID";
            var con = Configuration.getInstance().getConnection();
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@TransactionID", transactionID);
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);
            dataGridView5.DataSource = dataTable;


        }
        public void PopulateDataGridView2(int rowIndex)
        {
            string transactionID = dataGridView1.Rows[rowIndex].Cells["TransactionID"].Value.ToString();
            string query = @"
        SELECT cc.*
        FROM CreditCard cc
        INNER JOIN PaymentMethod pm ON cc.CreditCardID = pm.CreditCardID
        INNER JOIN Transactions t ON pm.PaymentMethodID = t.PaymentMethodID
        WHERE t.TransactionID = @TransactionID
    ";
            var con = Configuration.getInstance().getConnection();
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@TransactionID", transactionID);
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);
            dataGridView2.DataSource = dataTable;

        }

        public void PopulateDataGridView3(int rowIndex)
        {
            string transactionID = dataGridView1.Rows[rowIndex].Cells["TransactionID"].Value.ToString();
            string query = @"
        SELECT cc.*
        FROM Cheque cc
        INNER JOIN PaymentMethod pm ON cc.ChequeID = pm.ChequeID
        INNER JOIN Transactions t ON pm.PaymentMethodID = t.PaymentMethodID
        WHERE t.TransactionID = @TransactionID";
            var con = Configuration.getInstance().getConnection();
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@TransactionID", transactionID);
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);
            dataGridView3.DataSource = dataTable;

        }
        private void button1_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage1;
            tabControl2.SelectedTab = tabPage7;
        }
        private void btnCreate_Click(object sender, EventArgs e)
        {
            // Check if any required field is empty
            if (string.IsNullOrEmpty(txtFirst.Text))
            {
                MessageBox.Show("First Name cannot be empty.");
                return;
            }
            if (!Validity.IsAlpha(txtFirst.Text))
            {
                MessageBox.Show("First Name should contain only alphabetic characters.");
                return;
            }
            if (!Validity.IsAlphaLast(txtLast.Text))
            {
                MessageBox.Show("Last Name should contain only alphabetic characters.");
                return;
            }
            if (!Validity.IsEmailValid(txtEmail.Text))
            {
                MessageBox.Show("Invalid email format.");
                return;
            }
            if (string.IsNullOrEmpty(txtEmail.Text))
            {
                MessageBox.Show("Email cannot be empty.");
                return;
            }
            if (!Validity.IsValidPhoneNumber(txtContact.Text))
            {
                MessageBox.Show("Invalid Contact format.");
                return;
            }
            if (string.IsNullOrEmpty(txtPassword.Text) || !Validity.IsValidPassword(txtPassword.Text))
            {
                MessageBox.Show("Invalid or empty password.");
                return;
            }
            if (string.IsNullOrEmpty(txtUsername.Text) || !Validity.IsValidUsername(txtUsername.Text))
            {
                MessageBox.Show("Invalid or empty username.");
                return;
            }

            // Begin a database transaction
            var con = Configuration.getInstance().getConnection();

            SqlTransaction transaction = con.BeginTransaction();
             SqlCommand cmdCheckExisting = con.CreateCommand();
                cmdCheckExisting.Transaction = transaction;
                cmdCheckExisting.CommandText = "SELECT COUNT(*) FROM UserCredentials WHERE Username = @Username OR Password = @Password;";
                cmdCheckExisting.Parameters.AddWithValue("@Username", txtUsername.Text);
                cmdCheckExisting.Parameters.AddWithValue("@Password", txtPassword.Text);
                int existingCount = Convert.ToInt32(cmdCheckExisting.ExecuteScalar());

                if (existingCount > 0)
                {
                    MessageBox.Show("Username or password already exists. Please choose a different one.");
                    return;
                }

            SqlCommand cmdPerson = con.CreateCommand();
            cmdPerson.Transaction = transaction;
            SqlCommand cmdCheckAuditors = con.CreateCommand();
            cmdCheckAuditors.Transaction = transaction;
            cmdCheckAuditors.CommandText = "SELECT COUNT(*) FROM Auditor";
            int currentAuditorCount = Convert.ToInt32(cmdCheckAuditors.ExecuteScalar());

            if (currentAuditorCount >= 3)
            {
                MessageBox.Show("Only three auditors can be present in the firm.");
                ClearAllTextBoxes(panel2);
                tabControl1.SelectedTab = AuditMain;

                return;
            }

            cmdPerson.CommandText = "INSERT INTO Person (FirstName, LastName, Gender, Contact, Email) " +
                                    "VALUES (@FirstName, @LastName, @Gender, @Contact, @Email); " +
                                    "SELECT SCOPE_IDENTITY();";
            cmdPerson.Parameters.AddWithValue("@FirstName", txtFirst.Text);
            cmdPerson.Parameters.AddWithValue("@LastName", txtLast.Text);
            string gender = (chkMale.Checked) ? "Male" : (chkFemale.Checked) ? "Female" : null;
            cmdPerson.Parameters.AddWithValue("@Gender", gender);
            cmdPerson.Parameters.AddWithValue("@Contact", txtContact.Text);
            cmdPerson.Parameters.AddWithValue("@Email", txtEmail.Text);
            int personID = Convert.ToInt32(cmdPerson.ExecuteScalar());

            if (personID > 0)
            {
                string role = comboBox2.SelectedItem.ToString();
                SqlCommand cmdAuditor = con.CreateCommand();
                cmdAuditor.Transaction = transaction;
                cmdAuditor.CommandText = "INSERT INTO Auditor (AuditorID, Role , JoinedDate) " +
                                         "VALUES (@AuditorID,  @Role , @JoinedDate);";
                cmdAuditor.Parameters.AddWithValue("@AuditorID", personID);
                cmdAuditor.Parameters.AddWithValue("@Role", role);
                cmdAuditor.Parameters.AddWithValue("@JoinedDate", DateTime.Now);
                int rowsAffected = cmdAuditor.ExecuteNonQuery();

                // Insert data into the UserCredentials table
                if (Validity.IsValidPassword(txtPassword.Text) && Validity.IsValidUsername(txtUsername.Text))
                {
                    SqlCommand cmdUserCredentials = con.CreateCommand();
                    cmdUserCredentials.Transaction = transaction;
                    cmdUserCredentials.CommandText = "INSERT INTO UserCredentials (Username, Password, PersonID) " +
                                                      "VALUES (@Username, @Password, @PersonID);";
                    cmdUserCredentials.Parameters.AddWithValue("@Username", txtUsername.Text);
                    cmdUserCredentials.Parameters.AddWithValue("@Password", txtPassword.Text);
                    cmdUserCredentials.Parameters.AddWithValue("@PersonID", personID);
                    int rowsAffected1 = cmdUserCredentials.ExecuteNonQuery();

                    if (rowsAffected > 0 && rowsAffected1 > 0)
                    {
                        transaction.Commit();
                        MessageBox.Show("Account created Successfully ");
                        tabControl1.SelectedTab = AuditMain;
                    }
                    else
                    {
                        transaction.Rollback();
                        MessageBox.Show("Error storing user credentials.");
                    }
                }
                else
                {
                    transaction.Rollback();
                    MessageBox.Show("Invalid username or password.");
                }
            }
            else
            {
                transaction.Rollback();
                MessageBox.Show("Error adding Person or retrieving DepartmentID");
            }
            ClearAllTextBoxes(panel2);
        }
        private void ClearAllTextBoxes(Control container)
        {

            foreach (Control control in container.Controls)
            {

                if (control is System.Windows.Forms.TextBox)
                {
                    ((System.Windows.Forms.TextBox)control).Clear();
                }
                else if (control is GroupBox || control is Panel)
                {
                    ClearAllTextBoxes(control);

                }
            }
        }
        public static int GetDepartmentIDFromDatabase(string departmentName, SqlTransaction transaction)
        {
            int departmentID = -1;

            var con = Configuration.getInstance().getConnection();
            SqlCommand cmd = new SqlCommand("SELECT DepartmentID FROM Department WHERE DepartmentName = @DepartmentName;", con);
            cmd.Parameters.AddWithValue("@DepartmentName", departmentName);

            // Assign the transaction to the command
            cmd.Transaction = transaction;

            object result = cmd.ExecuteScalar();
            if (result != null)
            {
                departmentID = Convert.ToInt32(result);
            }
            else
            {
                MessageBox.Show("Department not found in the database.");
            }
            return departmentID;
        }



        private void btnBacks_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = AuditMain;
        }

        private void btnAccount_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage2;
        }

        private void btnSign_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage3;
        }

        private void btnBackss_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage6;
        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = AuditMain;
        }

        private void btnNext_Click(object sender, EventArgs e)
        {

            if (cmbRole.SelectedItem.ToString() == "Auditor")
            {
                tabControl1.SelectedTab = AuditMain;
            }
            if (cmbRole.SelectedItem.ToString() == "Partner")
            {

                tabControl1.SelectedTab = tabPage20;
            }
        }

        private void btnSignIn_Click(object sender, EventArgs e)
        {
            var con = Configuration.getInstance().getConnection();
            SqlTransaction transaction = con.BeginTransaction();
            SqlCommand cmd = con.CreateCommand();
            cmd.Transaction = transaction;
            cmd.CommandText = "SELECT a.AuditorID FROM UserCredentials uc " +
                                "INNER JOIN Auditor a ON a.AuditorID = uc.PersonID " +
                                "WHERE uc.Username = @Username AND uc.Password = @Password";
            cmd.Parameters.AddWithValue("@Username", txtUS.Text);
            cmd.Parameters.AddWithValue("@Password", txtPS.Text);
            object result = cmd.ExecuteScalar();
            if (result != null)
            {
                AuditorID = Convert.ToInt32(result);

                MessageBox.Show("Successfully signed In as an Auditor");
                SqlCommand updateCmd = con.CreateCommand();
                updateCmd.Transaction = transaction;
                updateCmd.CommandText = "UPDATE UserCredentials SET LastLoginDate = @LastLoginDate WHERE Username = @Username";
                updateCmd.Parameters.AddWithValue("@LastLoginDate", DateTime.Now);
                updateCmd.Parameters.AddWithValue("@Username", txtUS.Text);
                updateCmd.ExecuteNonQuery();
                transaction.Commit();
                showAlerst();
                tabControl1.SelectedTab = tabPage4;
            }
            else
            {
                transaction.Rollback();
                MessageBox.Show("No account exists or you are not an Auditor");
            }
        }
        private void btnBackk_Click_1(object sender, EventArgs e)
        {
            dataGridView2.Visible = false;
            dataGridView3.Visible = false;
            dataGridView4.Visible = false;
            dataGridView5.Visible = false;
            button5.Visible = true;
        }
        private void dataGridView6_RowPrePaint(object sender, DataGridViewRowPrePaintEventArgs e)
        {
            if (dataGridView6.Columns.Contains("FraudRisk") && dataGridView6.Rows[e.RowIndex].Cells["FraudRisk"].Value != null)
            {
                string fraudRisk = dataGridView6.Rows[e.RowIndex].Cells["FraudRisk"].Value.ToString();
                if (fraudRisk == "Anomaly")
                {
                    dataGridView6.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Red;
                }
                else if (fraudRisk == "High Risk Fraud")
                {
                    dataGridView6.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Yellow;
                }
                else if (fraudRisk == "Moderate Risk Fraud")
                {
                    dataGridView6.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Orange;
                }
                else
                {
                    dataGridView6.Rows[e.RowIndex].DefaultCellStyle.BackColor = dataGridView6.DefaultCellStyle.BackColor;
                }
            }
        }

        public void fruaalert(DataGridView dataGridView6)
        {
            var con = Configuration.getInstance().getConnection();
            string Reas = "Null";
            if (dataGridView6.DataSource is DataTable mergedDataTable)
            {

                foreach (DataRow row in mergedDataTable.Rows)
                {
                    int alertID = 0;
                    if (row["FraudRisk"] != null && row["FraudRisk"].ToString() != "Normal")
                    {
                        string insertQuery = @"
        INSERT INTO FraudAlerts (TransactionID, AlertDate, AlertReason, AuditID)
        VALUES (@TransactionID, @AlertDate, @AlertReason, @AuditID);
        SELECT SCOPE_IDENTITY();";
                        SqlCommand insertCmd = new SqlCommand(insertQuery, con);
                        insertCmd.Parameters.AddWithValue("@AuditID", AuditID);
                        insertCmd.Parameters.AddWithValue("@TransactionID", row["TransactionID"]);
                        insertCmd.Parameters.AddWithValue("@AlertDate", DateTime.Today);
                        insertCmd.Parameters.AddWithValue("@AlertReason", row["FraudRisk"]);
                        Reas = row["FraudRisk"].ToString();
                        object results = insertCmd.ExecuteScalar();
                        if (results != null)
                        {
                            alertID = Convert.ToInt32(results);
                            MarkAuditAsComplete();
                        }
                    }
                    string audits = "True and Fair";
                    string result = "Qualified";
                    string reason = "Normal";
                    object alertIDParameter = DBNull.Value;
                    if (row["FraudRisk"] == null || row["FraudRisk"].ToString() == "Normal")
                    {
                        audits = "True and fair";
                        result = "Unqualified";
                        reason = "Normal";
                    }
                    else
                    {
                        audits = "Not fair";
                        result = "Qualified";
                        alertIDParameter = alertID;
                        reason = Reas;
                    }

                    // Insert into AuditorAction table
                    string insertActionQuery = @"
    INSERT INTO AuditorAction (AlertID, ActionDate, TransactionID, AuditID,ActionReason ,  AuditAction, AuditResult)
    VALUES (@AlertID, @ActionDate, @TransactionID, @AuditID, @ActionReason , @AuditAction, @AuditResult)";
                    SqlCommand insertActionCmd = new SqlCommand(insertActionQuery, con);
                    insertActionCmd.Parameters.AddWithValue("@AlertID", alertIDParameter);
                    insertActionCmd.Parameters.AddWithValue("@TransactionID", row["TransactionID"]);
                    insertActionCmd.Parameters.AddWithValue("@ActionDate", DateTime.Today);
                    insertActionCmd.Parameters.AddWithValue("@AuditID", AuditID);
                    insertActionCmd.Parameters.AddWithValue("@ActionReason", reason);
                    insertActionCmd.Parameters.AddWithValue("@AuditAction", audits);
                    insertActionCmd.Parameters.AddWithValue("@AuditResult", result);
                    insertActionCmd.ExecuteNonQuery();
                }
                MarkAuditAsComplete();
            }
        }

        public void MarkAuditAsComplete()
        {
            var con = Configuration.getInstance().getConnection();
            string updateQuery = @"
            UPDATE Audit
            SET AuditStatus = 'complete'
            WHERE AuditID = @AuditID";
            SqlCommand updateCmd = new SqlCommand(updateQuery, con);
            updateCmd.Parameters.AddWithValue("@AuditID", AuditID);
            int rowsAffected = updateCmd.ExecuteNonQuery();
            if (rowsAffected > 0)
            {
                Console.WriteLine("Audit marked as complete successfully.");
            }
            else
            {
                Console.WriteLine("No audit found with the specified ID.");
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            tabControl2.SelectedTab = tabPage8;
        }

        private void BindDataToChart(Chart chart1, DataTable dataTable)
        {
            chart1.Series.Clear();
            chart1.ChartAreas.Clear();
            ChartArea chartArea = new ChartArea();
            chart1.ChartAreas.Add(chartArea);
            Series amountSeries = new Series("Transaction Amount");
            amountSeries.ChartType = SeriesChartType.Column;
            amountSeries.XValueType = ChartValueType.Int32;
            chart1.Series.Add(amountSeries);
            chartArea.AxisX.Title = "Transaction ID";
            chartArea.AxisX.TitleForeColor = Color.Black;
            chartArea.AxisY.Title = "Amount";
            chartArea.AxisY.TitleForeColor = Color.Black;
            Legend legend = chart1.Legends.FindByName("fraudLegend");
            if (legend == null)
            {
                legend = new Legend();
                legend.Name = "fraudLegend";
                chart1.Legends.Add(legend);
                LegendItem anomalyItem = new LegendItem();
                anomalyItem.Name = "Anomaly";
                anomalyItem.Color = Color.Red;
                LegendItem highRiskItem = new LegendItem();
                highRiskItem.Name = "High Risk Fraud";
                highRiskItem.Color = Color.Yellow;
                LegendItem moderateRiskItem = new LegendItem();
                moderateRiskItem.Name = "Moderate Risk Fraud";
                moderateRiskItem.Color = Color.Orange;
                legend.CustomItems.Add(anomalyItem);
                legend.CustomItems.Add(highRiskItem);
                legend.CustomItems.Add(moderateRiskItem);
            }
            foreach (DataRow row in dataTable.Rows)
            {
                int transactionID = Convert.ToInt32(row["TransactionID"]);
                double transactionAmount = Convert.ToDouble(row["Amount"]);
                string fraudRisk = row["FraudRisk"].ToString();
                DataPoint dataPoint = new DataPoint(transactionID, transactionAmount);
                amountSeries.Points.Add(dataPoint);
                if (fraudRisk == "Anomaly")
                {
                    dataPoint.Color = Color.Red;
                }
                else if (fraudRisk == "High Risk Fraud")
                {
                    dataPoint.Color = Color.Yellow;
                }
                else if (fraudRisk == "Moderate Risk Fraud")
                {
                    dataPoint.Color = Color.Orange;
                }
                else
                {
                    dataPoint.Color = Color.Blue;
                }
            }
        }


        private void button4_Click(object sender, EventArgs e)
        {
            var con = Configuration.getInstance().getConnection();
            DataTable combinedDataTable = new DataTable();
            DateTime selectedMonth = dateTimePicker2.Value.Date;
            SqlCommand creditCardCmd = new SqlCommand("GetCreditCardAnomalies", con);
            SqlDataAdapter creditCardAdapter = new SqlDataAdapter(creditCardCmd);
            creditCardCmd.CommandType = CommandType.StoredProcedure;
            creditCardCmd.Parameters.AddWithValue("@SelectedMonth", selectedMonth);
            DataTable creditCardDataTable = new DataTable();
            creditCardAdapter.Fill(creditCardDataTable);
            tabControl2.SelectedTab = tabPage5;
            dataGridView6.RowPrePaint += dataGridView6_RowPrePaint;
            dataGridView6.DataSource = creditCardDataTable;
            dataGridView6.Columns["CreditCardID"].Width = 60;
            dataGridView6.Columns["TransactionID"].Width = 60;
            dataGridView6.Columns["Amount"].Width = 80;
            dataGridView6.Columns["Date"].Width = 80;
            dataGridView6.Columns["FraudRisk"].Width = 120;
            dataGridView6.Refresh();
            fruaalert(dataGridView6);
            BindDataToChart(chart1, (DataTable)dataGridView6.DataSource);

        }
        private void button9_Click(object sender, EventArgs e)
        {

            var con = Configuration.getInstance().getConnection();
            DateTime selectedMonth = dateTimePicker2.Value.Date;
            DataTable combinedDataTable = new DataTable();
            SqlCommand chequeCmd = new SqlCommand("GetChequeTransactions", con);
            SqlDataAdapter chequeAdapter = new SqlDataAdapter(chequeCmd);
            chequeCmd.CommandType = CommandType.StoredProcedure;
            chequeCmd.Parameters.AddWithValue("@SelectedMonth", selectedMonth);
            DataTable chequeDataTable = new DataTable();
            chequeAdapter.Fill(chequeDataTable);
            tabControl2.SelectedTab = tabPage13;
            dataGridView8.RowPrePaint += dataGridView8_RowPrePaint;
            dataGridView8.DataSource = chequeDataTable;
            dataGridView8.Columns["ChequeID"].Width = 60;
            dataGridView8.Columns["TransactionID"].Width = 60;
            dataGridView8.Columns["Amount"].Width = 80;
            dataGridView8.Columns["Date"].Width = 80;
            dataGridView8.Columns["FraudRisk"].Width = 120;
            dataGridView8.Refresh();
            fruaalert(dataGridView8);
            BindDataToChart(chart2, (DataTable)dataGridView8.DataSource);

        }

        private void button8_Click(object sender, EventArgs e)
        {
            var con = Configuration.getInstance().getConnection();
            DateTime selectedMonth = dateTimePicker2.Value.Date;
            DataTable combinedDataTable = new DataTable();
            SqlCommand onlineCmd = new SqlCommand("GetOnlineTransactions", con);
            SqlDataAdapter onlineAdapter = new SqlDataAdapter(onlineCmd);
            onlineCmd.CommandType = CommandType.StoredProcedure;
            onlineCmd.Parameters.AddWithValue("@SelectedMonth", selectedMonth);
            DataTable onlineDataTable = new DataTable();
            onlineAdapter.Fill(onlineDataTable);
            tabControl2.SelectedTab = tabPage14;
            dataGridView9.RowPrePaint += dataGridView9_RowPrePaint;
            dataGridView9.DataSource = onlineDataTable;
            dataGridView9.Columns["OnlineID"].Width = 60;
            dataGridView9.Columns["TransactionID"].Width = 60;
            dataGridView9.Columns["Amount"].Width = 80;
            dataGridView9.Columns["Date"].Width = 80;
            dataGridView9.Columns["FraudRisk"].Width = 120;
            dataGridView9.Refresh();
            fruaalert(dataGridView9);
            BindDataToChart(chart3, (DataTable)dataGridView9.DataSource);
        }
        private void button10_Click(object sender, EventArgs e)
        {
            var con = Configuration.getInstance().getConnection();
            DateTime selectedMonth = dateTimePicker2.Value.Date;
            DataTable combinedDataTable = new DataTable();
            SqlCommand Installment = new SqlCommand("GetInstallmentAnomalies", con);
            SqlDataAdapter installmentAdapter = new SqlDataAdapter(Installment);
            Installment.CommandType = CommandType.StoredProcedure;
            Installment.Parameters.AddWithValue("@SelectedMonth", selectedMonth);
            DataTable installmentDataTable = new DataTable();
            installmentAdapter.Fill(installmentDataTable);
            tabControl2.SelectedTab = tabPage15;
            dataGridView10.RowPrePaint += dataGridView10_RowPrePaint;
            dataGridView10.DataSource = installmentDataTable;
            dataGridView10.Columns["TransactionID"].Width = 60;
            dataGridView10.Columns["InstallmentNumber"].Width = 60;
            dataGridView10.Columns["Amount"].Width = 80;
            dataGridView10.Columns["Date"].Width = 80;
            dataGridView10.Columns["FraudRisk"].Width = 120;
            dataGridView10.Refresh();
            fruaalert(dataGridView10);
            BindDataToChart(chart4, (DataTable)dataGridView10.DataSource);
        }
        private void button6_Click(object sender, EventArgs e)
        {
            var con = Configuration.getInstance().getConnection();
            DateTime selectedMonth = dateTimePicker2.Value.Date;
            DataTable combinedDataTable = new DataTable();
            SqlCommand command = new SqlCommand("IdentifyTransactionAnomalies", con);
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue("@SelectedMonth", selectedMonth);
            SqlDataAdapter adapter = new SqlDataAdapter(command);
            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);
            tabControl2.SelectedTab = tabPage16;
            dataGridView11.RowPrePaint += dataGridView11_RowPrePaint;
            dataGridView11.DataSource = dataTable;
            dataGridView11.Columns["TransactionID"].Width = 60;
            dataGridView11.Columns["Amount"].Width = 80;
            dataGridView11.Columns["Date"].Width = 80;
            dataGridView11.Columns["InvoiceID"].Width = 60;
            dataGridView11.Columns["InvoiceAmount"].Width = 60;
            dataGridView11.Columns["InvoiceDate"].Width = 60;
            dataGridView11.Columns["FraudRisk"].Width = 120;
            dataGridView11.Refresh();
            fruaalert(dataGridView11);
            BindDataToCharts(chart5, dataTable);
        }
        private void button7_Click(object sender, EventArgs e)
        {
            tabControl2.SelectedTab = tabPage8;
            dataGridView6.Refresh();
        }
        private void button12_Click(object sender, EventArgs e)
        {
            int selectedMonth = dateTimePicker1.Value.Month;
            var con = Configuration.getInstance().getConnection();
            string query = "SELECT DISTINCT TransactionID, AlertDate, AlertReason FROM FraudAlerts " +
                           "WHERE MONTH(AlertDate) = @SelectedMonth ";
            SqlCommand command = new SqlCommand(query, con);
            command.Parameters.AddWithValue("@SelectedMonth", selectedMonth);
            SqlDataAdapter adapter = new SqlDataAdapter(command);
            DataTable fraudAlertsDataTable = new DataTable();
            adapter.Fill(fraudAlertsDataTable);

            tabControl2.SelectedTab = tabPage10;
            dataGridView7.DataSource = fraudAlertsDataTable;
            dataGridView7.Columns["TransactionID"].Width = 100;
            dataGridView7.Columns["AlertDate"].Width = 120;
            dataGridView7.Columns["AlertReason"].Width = 160;
        }

        private void dataGridView8_RowPrePaint(object sender, DataGridViewRowPrePaintEventArgs e)
        {
            if (dataGridView8.Columns.Contains("FraudRisk") && dataGridView8.Rows[e.RowIndex].Cells["FraudRisk"].Value != null)
            {
                string fraudRisk = dataGridView8.Rows[e.RowIndex].Cells["FraudRisk"].Value.ToString();
                if (fraudRisk == "Anomaly")
                {
                    dataGridView8.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Red;
                }
                else if (fraudRisk == "High Risk Fraud")
                {
                    dataGridView8.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Yellow;
                }
                else if (fraudRisk == "Moderate Risk Fraud")
                {
                    dataGridView8.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Orange;
                }
                else
                {
                    dataGridView8.Rows[e.RowIndex].DefaultCellStyle.BackColor = dataGridView8.DefaultCellStyle.BackColor;
                }
            }
        }
        private void dataGridView9_RowPrePaint(object sender, DataGridViewRowPrePaintEventArgs e)
        {
            if (dataGridView9.Columns.Contains("FraudRisk") && dataGridView9.Rows[e.RowIndex].Cells["FraudRisk"].Value != null)
            {
                string fraudRisk = dataGridView9.Rows[e.RowIndex].Cells["FraudRisk"].Value.ToString();
                if (fraudRisk == "Anomaly")
                {
                    dataGridView9.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Red;
                }
                else if (fraudRisk == "High Risk Fraud")
                {
                    dataGridView9.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Yellow;
                }
                else if (fraudRisk == "Moderate Risk Fraud")
                {
                    dataGridView9.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Orange;
                }
                else
                {
                    dataGridView9.Rows[e.RowIndex].DefaultCellStyle.BackColor = dataGridView9.DefaultCellStyle.BackColor;
                }
            }
        }
        private void dataGridView10_RowPrePaint(object sender, DataGridViewRowPrePaintEventArgs e)
        {
            if (dataGridView10.Columns.Contains("FraudRisk") && dataGridView10.Rows[e.RowIndex].Cells["FraudRisk"].Value != null)
            {
                string fraudRisk = dataGridView10.Rows[e.RowIndex].Cells["FraudRisk"].Value.ToString();
                if (fraudRisk == "Anomaly")
                {
                    dataGridView10.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Red;
                }
                else if (fraudRisk == "High Risk Fraud")
                {
                    dataGridView10.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Yellow;
                }
                else if (fraudRisk == "Moderate Risk Fraud")
                {
                    dataGridView10.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Orange;
                }
                else
                {
                    dataGridView10.Rows[e.RowIndex].DefaultCellStyle.BackColor = dataGridView10.DefaultCellStyle.BackColor;
                }
            }
        }
        private void dataGridView11_RowPrePaint(object sender, DataGridViewRowPrePaintEventArgs e)
        {
            if (dataGridView11.Columns.Contains("FraudRisk") && dataGridView11.Rows[e.RowIndex].Cells["FraudRisk"].Value != null)
            {
                string fraudRisk = dataGridView11.Rows[e.RowIndex].Cells["FraudRisk"].Value.ToString();
                if (fraudRisk == "Anomaly")
                {
                    dataGridView11.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Red;
                }
            }
        }
        private void BindDataToCharts(Chart chart1, DataTable dataTable)
        {
            chart1.Series.Clear();
            chart1.ChartAreas.Clear();
            ChartArea chartArea = new ChartArea();
            chart1.ChartAreas.Add(chartArea);
            Series transactionSeries = new Series("Transaction Amount");
            transactionSeries.ChartType = SeriesChartType.Line;
            transactionSeries.XValueType = ChartValueType.Int32;
            chart1.Series.Add(transactionSeries);
            Series invoiceSeries = new Series("Invoice Amount");
            invoiceSeries.ChartType = SeriesChartType.Line;
            invoiceSeries.XValueType = ChartValueType.Int32;
            chart1.Series.Add(invoiceSeries);

            chartArea.AxisX.Title = "ID";
            chartArea.AxisX.TitleForeColor = Color.Black;
            chartArea.AxisY.Title = "Amount";
            chartArea.AxisY.TitleForeColor = Color.Black;
            foreach (DataRow row in dataTable.Rows)
            {
                int transactionID = Convert.ToInt32(row["TransactionID"]);
                double transactionAmount = Convert.ToDouble(row["Amount"]);
                int invoiceID;
                if (row["InvoiceID"] != DBNull.Value)
                {
                    invoiceID = Convert.ToInt32(row["InvoiceID"]);
                }
                else
                {
                    invoiceID = -1;
                }
                double invoiceAmount;
                if (row["InvoiceAmount"] != DBNull.Value)
                {
                    invoiceAmount = Convert.ToDouble(row["InvoiceAmount"]);
                }
                else
                {

                    invoiceAmount = 0;
                }
                DataPoint transactionDataPoint = new DataPoint(transactionID, transactionAmount);
                transactionSeries.Points.Add(transactionDataPoint);
                DataPoint invoiceDataPoint = new DataPoint(invoiceID, invoiceAmount);
                invoiceSeries.Points.Add(invoiceDataPoint);
                string fraudRisk = row["FraudRisk"].ToString();
                SetDataPointColor(transactionDataPoint, fraudRisk);
            }
        }
        private void SetDataPointColor(DataPoint dataPoint, string fraudRisk)
        {
            switch (fraudRisk)
            {
                case "Anomaly":
                    dataPoint.Color = Color.Red;
                    break;
                case "Normal":
                    dataPoint.Color = Color.Blue;
                    break;
            }
        }
        public void showAlerst()
        {
            var con = Configuration.getInstance().getConnection();
            string countQuery = "SELECT COUNT(DISTINCT TransactionID) AS TransactionCount FROM FraudAlerts " +
                                "WHERE AlertDate = (SELECT MAX(AlertDate) FROM FraudAlerts)";
            var countCommand = new SqlCommand(countQuery, con);
            int transactionCount = (int)countCommand.ExecuteScalar();
            textBox1.Text = transactionCount.ToString();
        }
        private void ShowFraudAlertsMenu()
        {
            var con = Configuration.getInstance().getConnection();
            string query = "SELECT DISTINCT TransactionID, AlertDate, AlertReason FROM FraudAlerts " +
                           "WHERE AlertDate = (SELECT MAX(AlertDate) FROM FraudAlerts)";
            if (con.State != ConnectionState.Closed)
            {
                con.Close();
            }
            con.Open();

            var command = new SqlCommand(query, con);
            var reader = command.ExecuteReader();
            alertMenu.BackColor = Color.SkyBlue;
            alertMenu.ForeColor = Color.DarkBlue;
            alertMenu.Items.Clear();
            while (reader.Read())
            {
                int transactionID = Convert.ToInt32(reader["TransactionID"]);
                DateTime alertDate = Convert.ToDateTime(reader["AlertDate"]);
                string alertReason = reader["AlertReason"].ToString();
                ToolStripMenuItem menuItem = new ToolStripMenuItem($"Transaction ID: {transactionID}, Reason: {alertReason}");
                alertMenu.Items.Add(menuItem);
            }
            reader.Close();
            alertMenu.Show(pictureBox2, new System.Drawing.Point(0, pictureBox2.Height));
        }

        private void bTNAudit_Click(object sender, EventArgs e)
        {
            tabControl2.SelectedTab = tabPage7;
        }

        private void button13_Click_1(object sender, EventArgs e)
        {
            tabControl2.SelectedTab = tabPage8;
            dataGridView8.Refresh();

        }
        private void button14_Click(object sender, EventArgs e)
        {

            tabControl2.SelectedTab = tabPage8;
            dataGridView9.Refresh();
        }

        private void button15_Click(object sender, EventArgs e)
        {
            tabControl2.SelectedTab = tabPage8;
            dataGridView10.Refresh();
        }

        private void button16_Click(object sender, EventArgs e)
        {
            tabControl2.SelectedTab = tabPage8;
            dataGridView11.Refresh();
        }


        private void button11_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage4;
        }
        private void button17_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage1;
            tabControl2.SelectedTab = tabPage12;
        }

        private void pictureBox2_Click_1(object sender, EventArgs e)
        {
            ShowFraudAlertsMenu();
            textBox1.Visible = false;
        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage1;
            tabControl2.SelectedTab = tabPage7;
        }

        private void button19_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage4;

        }

        private void button2_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage1;
            tabControl2.SelectedTab = tabPage11;
        }

        private void button21_Click(object sender, EventArgs e)
        {
            int selectedMonth = dateTimePicker3.Value.Month;
            var con = Configuration.getInstance().getConnection();
            string query = "SELECT DISTINCT TransactionID, ActionReason , AuditAction , AuditResult FROM AuditorAction " +
                           "WHERE MONTH(ActionDate) = @SelectedMonth ";
            SqlCommand command = new SqlCommand(query, con);
            command.Parameters.AddWithValue("@SelectedMonth", selectedMonth);
            SqlDataAdapter adapter = new SqlDataAdapter(command);
            DataTable fraudAlertsDataTable = new DataTable();
            adapter.Fill(fraudAlertsDataTable);
            tabControl2.SelectedTab = tabPage17;
            dataGridView12.DataSource = fraudAlertsDataTable;
            dataGridView12.Columns["TransactionID"].Width = 60;
            dataGridView12.Columns["ActionReason"].Width = 90;
            dataGridView12.Columns["AuditAction"].Width = 140;
            dataGridView12.Columns["AuditResult"].Width = 140;
            BindDataToChartAudit(chart6);
        }
        private void dataGridView12_RowPrePaint(object sender, DataGridViewRowPrePaintEventArgs e)
        {
            if (dataGridView12.Columns.Contains("AuditAction") && dataGridView12.Rows[e.RowIndex].Cells["AuditAction"].Value != null)
            {
                string fraudRisk = dataGridView12.Rows[e.RowIndex].Cells["AusditAction"].Value.ToString();
                if (fraudRisk == "Not Fair")
                {
                    dataGridView12.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.Red;
                }
                else
                {
                    dataGridView12.Rows[e.RowIndex].DefaultCellStyle.BackColor = dataGridView12.DefaultCellStyle.BackColor;
                }
            }
        }
        private void BindDataToChartAudit(Chart chart1)
        {
            // Clear existing series and chart areas
            chart1.Series.Clear();
            chart1.ChartAreas.Clear();

            // Create a new chart area
            ChartArea chartArea = new ChartArea();
            chart1.ChartAreas.Add(chartArea);

            // Create a new series for the counts
            Series countSeries = new Series("Audit Counts");
            countSeries.ChartType = SeriesChartType.Column;
            countSeries.XValueType = ChartValueType.String;
            chart1.Series.Add(countSeries);

            // Set titles and colors for axes
            chartArea.AxisX.Title = "Transaction Type";
            chartArea.AxisX.TitleForeColor = Color.Black;
            chartArea.AxisY.Title = "Count";
            chartArea.AxisY.TitleForeColor = Color.Black;

            // Set axis label interval to 1 to avoid overlapping
            chartArea.AxisX.Interval = 1;
            Legend legend = chart1.Legends.FindByName("fraudLegend");
            if (legend == null)
            {
                legend = new Legend();
                legend.Name = "fraudLegend";
                chart1.Legends.Add(legend);
                LegendItem anomalyItem = new LegendItem();
                anomalyItem.Name = "Not Fair ";
                anomalyItem.Color = Color.Red;
                LegendItem highRiskItem = new LegendItem();
                highRiskItem.Name = "True and Fair";
                highRiskItem.Color = Color.Blue;
                legend.CustomItems.Add(anomalyItem);
                legend.CustomItems.Add(highRiskItem);
            }
            // Retrieve counts from the database
            int trueAndFairCount = GetAuditCount("True and fair");
            int notFairCount = GetAuditCount("Not fair");

            // Add data points to the series
            DataPoint trueAndFairPoint = new DataPoint(0, trueAndFairCount);
            DataPoint notFairPoint = new DataPoint(1, notFairCount);

            countSeries.Points.Add(trueAndFairPoint);
            countSeries.Points.Add(notFairPoint);

            // Set the color of "Not fair" bars to red
            notFairPoint.Color = Color.Red;

            // Adjust the Y-axis range based on the maximum count
            int maxCount = Math.Max(trueAndFairCount, notFairCount);
            chartArea.AxisY.Maximum = maxCount + 10; // Add some buffer for better visualization
        }


        private int GetAuditCount(string auditAction)
        {
            int count = 0;
            var con = Configuration.getInstance().getConnection();
            string query = "SELECT COUNT(*) FROM AuditorAction WHERE AuditAction = @AuditAction";
            SqlCommand command = new SqlCommand(query, con);

            command.Parameters.AddWithValue("@AuditAction", auditAction);
            count = (int)command.ExecuteScalar();
            return count;
        }

        private void button18_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage6;
        }

        private void button20_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage4;
        }

        private void button22_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage4;
        }

        private void btnAcc_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage19;
        }

        private void btnSigning_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage18;
        }

        private void btnb_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage6;
        }

        private void btnC_Click(object sender, EventArgs e)
        {

            // Validation for input fields
            if (string.IsNullOrEmpty(txtFN.Text) || !Validity.IsAlpha(txtFN.Text))
            {
                MessageBox.Show("Invalid or empty first name.");
                return;
            }
            if (string.IsNullOrEmpty(txtLN.Text) || !Validity.IsAlphaLast(txtLN.Text))
            {
                MessageBox.Show("Invalid or empty last name.");
                return;
            }
            if (string.IsNullOrEmpty(txtE.Text) || !Validity.IsEmailValid(txtE.Text))
            {
                MessageBox.Show("Invalid or empty email.");
                return;
            }
            if (string.IsNullOrEmpty(txtC.Text) || !Validity.IsValidPhoneNumber(txtC.Text))
            {
                MessageBox.Show("Invalid or empty contact.");
                return;
            }
            if (string.IsNullOrEmpty(txtP.Text) || Validity.IsValidPassword(txtP.Text))
            {
                MessageBox.Show("Invalid or empty password.");
                return;
            }
            if (string.IsNullOrEmpty(txtU.Text) || Validity.IsValidUsername(txtU.Text))
            {
                MessageBox.Show("Invalid or empty contact.");
                return;
            }
            if (string.IsNullOrEmpty(cmbRoles.Text) )
            {
                MessageBox.Show("Invalid or empty role");
                return;
            }
            if (string.IsNullOrEmpty(txtTI.Text))
            {
                MessageBox.Show("Invalid or empty tota Investment");
                return;
            }
            if (string.IsNullOrEmpty(cmbDepartment.Text))
            {
                MessageBox.Show("Invalid or empty deaprtment");
                return;
            }
            var con = Configuration.getInstance().getConnection();
            SqlTransaction transaction = con.BeginTransaction();

            try
            {
                // Check if username or password already exists
                SqlCommand cmdCheckExisting = con.CreateCommand();
                cmdCheckExisting.Transaction = transaction;
                cmdCheckExisting.CommandText = "SELECT COUNT(*) FROM UserCredentials WHERE Username = @Username OR Password = @Password;";
                cmdCheckExisting.Parameters.AddWithValue("@Username", txtU.Text);
                cmdCheckExisting.Parameters.AddWithValue("@Password", txtP.Text);
                int existingCount = Convert.ToInt32(cmdCheckExisting.ExecuteScalar());

                if (existingCount > 0)
                {
                    MessageBox.Show("Username or password already exists. Please choose a different one.");
                    return;
                }
                SqlCommand cmdPerson = con.CreateCommand();
                cmdPerson.Transaction = transaction;
                SqlCommand cmdAuditor = con.CreateCommand();
                cmdAuditor.Transaction = transaction;

                cmdPerson.CommandText = "INSERT INTO Person (FirstName, LastName, Gender, Contact, Email) " +
                                        "VALUES (@FirstName, @LastName, @Gender, @Contact, @Email); " +
                                        "SELECT SCOPE_IDENTITY();";
                cmdPerson.Parameters.AddWithValue("@FirstName", txtFN.Text);
                cmdPerson.Parameters.AddWithValue("@LastName", txtLN.Text);
                string gender = (chkM.Checked) ? "Male" : (chkF.Checked) ? "Female" : null;
                cmdPerson.Parameters.AddWithValue("@Gender", gender);
                cmdPerson.Parameters.AddWithValue("@Contact", txtC.Text);
                cmdPerson.Parameters.AddWithValue("@Email", txtE.Text);
                int personID = Convert.ToInt32(cmdPerson.ExecuteScalar());

                if (personID > 0)
                {
                    string department = cmbDepartment.SelectedItem.ToString();
                    int departmentID = GetDepartmentIDFromDatabase(department, transaction);

                    if (departmentID > 0)
                    {
                        string role = cmbRoles.SelectedItem.ToString();
                        decimal totalInvestment;
                        if (!decimal.TryParse(txtTI.Text, out totalInvestment))
                        {
                            MessageBox.Show("Invalid input for partner's total investment.");
                            return;
                        }

                        decimal withdrawalThreshold = (decimal)0.05 * totalInvestment + (decimal)0.10 * totalInvestment;
                        cmdAuditor.CommandText = "INSERT INTO Partner (PartnerID, DepartmentID, TotalInvestment, WithdrawalThreshold, Role) " +
                                                  "VALUES (@PartnerID, @DepartmentID, @TotalInvestment, @WithdrawalThreshold, @Role);";
                        cmdAuditor.Parameters.AddWithValue("@PartnerID", personID);
                        cmdAuditor.Parameters.AddWithValue("@DepartmentID", departmentID);
                        cmdAuditor.Parameters.AddWithValue("@TotalInvestment", totalInvestment);
                        cmdAuditor.Parameters.AddWithValue("@WithdrawalThreshold", withdrawalThreshold);
                        cmdAuditor.Parameters.AddWithValue("@Role", role);

                        int rowsAffected = cmdAuditor.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            Validity.IsValidPassword(txtP.Text);
                            Validity.IsValidUsername(txtU.Text);
                            SqlCommand cmdUserCredentials = con.CreateCommand();
                            cmdUserCredentials.Transaction = transaction;
                            cmdUserCredentials.CommandText = "INSERT INTO UserCredentials (Username, Password, PersonID) VALUES (@Username, @Password, @PersonID);";
                            cmdUserCredentials.Parameters.AddWithValue("@Username", txtU.Text);
                            cmdUserCredentials.Parameters.AddWithValue("@Password", txtP.Text);
                            cmdUserCredentials.Parameters.AddWithValue("@PersonID", personID);

                            cmdUserCredentials.ExecuteNonQuery();

                            transaction.Commit();
                            MessageBox.Show("Account created successfully.");
                            tabControl1.SelectedTab = tabPage20;
                        }
                        else
                        {
                            transaction.Rollback();
                            MessageBox.Show("Error adding partner.");
                        }
                    }
                    else
                    {
                        transaction.Rollback();
                        MessageBox.Show("Invalid department selected.");
                    }
                }
                else
                {
                    transaction.Rollback();
                    MessageBox.Show("Error adding person.");
                }
            }
            catch (Exception ex)
            {
                transaction.Rollback();
                MessageBox.Show("An error occurred: " + ex.Message);
            }
            finally
            {
                ClearAllTextBoxes(panel7);
            }
        }

        private void btnSignIns_Click(object sender, EventArgs e)
        {
            var con = Configuration.getInstance().getConnection();
            SqlCommand cmd = new SqlCommand("SELECT uc.PersonID FROM UserCredentials uc " +
                                             "INNER JOIN Person p ON uc.PersonID = p.PersonID " +
                                             "INNER JOIN Partner pa ON p.PersonID = pa.PartnerID " +
                                             "WHERE uc.Username = @Username AND uc.Password = @Password", con);
            cmd.Parameters.AddWithValue("@Username", txtUn.Text);
            cmd.Parameters.AddWithValue("@Password", txtPW.Text);
            object result = cmd.ExecuteScalar();
            if (result != null)
            {
                SqlCommand updateCmd = new SqlCommand("UPDATE UserCredentials SET LastLoginDate = @LastLoginDate WHERE Username = @Username", con);
                updateCmd.Parameters.AddWithValue("@LastLoginDate", DateTime.Now);
                updateCmd.Parameters.AddWithValue("@Username", txtUn.Text);
                string username = txtUn.Text;
                string password = txtPW.Text;
                partnerid = Convert.ToInt32(result);
                MessageBox.Show("Successfully signed In as a Partner");
                tabControl1.SelectedTab = tabPage24;
            }
            else
            {
                MessageBox.Show("No account exists or you are not a Partner");
            }

        }

        private void button23_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage20;
        }

        private void btnBa_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage20;
        }

        private void button26_Click(object sender, EventArgs e)
        {
            MerchantStatus.SelectedItem = "Active";
            if (string.IsNullOrEmpty(FirstName.Text) || !Validity.IsAlpha(FirstName.Text))
            {
                MessageBox.Show("Invalid or empty first name.");
                return;
            }
            if (string.IsNullOrEmpty(LastName.Text) || !Validity.IsAlphaLast(LastName.Text))
            {
                MessageBox.Show("Invalid or empty last name.");
                return;
            }
            if (string.IsNullOrEmpty(Email.Text) || !Validity.IsEmailValid(Email.Text))
            {
                MessageBox.Show("Invalid or empty email.");
                return;
            }
            if (string.IsNullOrEmpty(Contact.Text) || !Validity.IsValidPhoneNumber(Contact.Text))
            {
                MessageBox.Show("Invalid or empty contact.");
                return;
            }
            if (string.IsNullOrEmpty(MerchantStatus.Text))
            {
                MessageBox.Show("Invalid or empty Status.");
                return;
            }
            if (string.IsNullOrEmpty(MerchantType.Text))
            {
                MessageBox.Show("Invalid or empty Type.");
                return;
            }
            var con = Configuration.getInstance().getConnection();
            SqlTransaction transaction = con.BeginTransaction();
            using (SqlCommand cmd = new SqlCommand("ManageMerchantTable", con, transaction))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@FirstName", FirstName.Text);
                cmd.Parameters.AddWithValue("@LastName", LastName.Text);
                cmd.Parameters.AddWithValue("@Gender", Gender.SelectedItem.ToString());
                cmd.Parameters.AddWithValue("@Contact", Contact.Text);
                cmd.Parameters.AddWithValue("@Email", Email.Text);
                cmd.Parameters.AddWithValue("@MerchantStatus", MerchantStatus.SelectedItem.ToString());
                cmd.Parameters.AddWithValue("@MerchantType", MerchantType.SelectedItem.ToString());
                cmd.Parameters.AddWithValue("@PartnerID", partnerid);
                SqlParameter merchantIdParam = new SqlParameter("@MerchantID", SqlDbType.Int);
                merchantIdParam.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(merchantIdParam);
                cmd.ExecuteNonQuery();
                int merchantId = Convert.ToInt32(cmd.Parameters["@MerchantID"].Value);

                MessageBox.Show("Data saved successfully. Merchant ID: " + merchantId);
                transaction.Commit();
                ClearAllTextBoxes(this);
            }
        }

        private void button25_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage22;
            PopulateComboBoxMerchant();


        }

        private void button24_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage23;
            PopulateComboBoxMerchant();

        }

        private void button27_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage24;

        }

        private void button29_Click(object sender, EventArgs e)
        {
            UpdateMerchantData();

        }

        private void View_Click(object sender, EventArgs e)
        {
            ShowDataInGrid();

        }

        private void button28_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage21;

        }
        private void button31_Click(object sender, EventArgs e)
        {
            SoftDeleteMerchantDataD();

        }
        private void button32_Click(object sender, EventArgs e)
        {
            ShowDataInGridD();
        }
        private void button30_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage21;
        }
        private void UpdateMerchantData()
        {
            if (string.IsNullOrEmpty(comboBox5.Text))
            {
                MessageBox.Show("Invalid or empty ID.");
                return;
            }
            if (string.IsNullOrEmpty(comboBox3.Text))
            {
                MessageBox.Show("Invalid or empty Status.");
                return;
            }
            if (string.IsNullOrEmpty(comboBox4.Text))
            {
                MessageBox.Show("Invalid or empty Type.");
                return;
            }
            var con = Configuration.getInstance().getConnection();
            string updateMerchantQuery = "UPDATE Merchant SET MerchantStatus = @MerchantStatus, " +
                                         "MerchantType = @MerchantType " +
                                         "WHERE MerchantID = @MerchantID";
            SqlCommand updateMerchantCommand = new SqlCommand(updateMerchantQuery, con);
            updateMerchantCommand.Parameters.AddWithValue("@MerchantID", comboBox5.SelectedItem.ToString());
            updateMerchantCommand.Parameters.AddWithValue("@MerchantStatus", comboBox3.SelectedItem.ToString());
            updateMerchantCommand.Parameters.AddWithValue("@MerchantType", comboBox4.SelectedItem.ToString());
            updateMerchantCommand.ExecuteNonQuery();
            MessageBox.Show("Data updated successfully.");
            ClearAllTextBoxes(this);
        }
        private void ShowDataInGrid()
        {
            var con = Configuration.getInstance().getConnection();
            string selectQuery = "SELECT * FROM Merchant WHERE MerchantStatus = 'Active'";
            SqlCommand command = new SqlCommand(selectQuery, con);
            SqlDataAdapter adapter = new SqlDataAdapter(command);
            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);
            dataGridView13.DataSource = dataTable;
            dataGridView13.ForeColor = Color.Black;
        }
        private void ShowDataInGridD()
        {
            var con = Configuration.getInstance().getConnection();
            string selectQuery = "SELECT * FROM Merchant WHERE MerchantStatus = 'Active'";
            SqlCommand command = new SqlCommand(selectQuery, con);
            SqlDataAdapter adapter = new SqlDataAdapter(command);
            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);
            dataGridView14.DataSource = dataTable;
            dataGridView14.ForeColor = Color.Black;
        }
        private void SoftDeleteMerchantDataD()
        {
            if (string.IsNullOrEmpty(comboBox6.Text))
            {
                MessageBox.Show("Please enter a valid MerchantID.");
                return;
            }
            var con = Configuration.getInstance().getConnection();
            string softDeleteMerchantQuery = "UPDATE Merchant SET MerchantStatus = 'Inactive' WHERE MerchantID = @MerchantID";
            SqlCommand softDeleteMerchantCommand = new SqlCommand(softDeleteMerchantQuery, con);
            softDeleteMerchantCommand.Parameters.AddWithValue("@MerchantID", comboBox6.SelectedItem.ToString());
            int rowsAffected = softDeleteMerchantCommand.ExecuteNonQuery();
            if (rowsAffected > 0)
            {
                MessageBox.Show("Data deleted successfully.");
                ClearAllTextBoxes(this);
                foreach (DataGridViewRow row in dataGridView14.Rows)
                {
                    if (row.Cells["MerchantID"].Value.ToString() == comboBox6.SelectedItem.ToString())
                    {
                        dataGridView14.Rows.Remove(row);
                        break;
                    }
                }
            }
            else
            {
                MessageBox.Show("No records updated. Please make sure the MerchantID is valid.");
            }
        }
        private void PopulateComboBoxMerchant()
        {
            var con = Configuration.getInstance().getConnection();
            comboBox5.Items.Clear();
            comboBox6.Items.Clear();
            string query = "SELECT MerchantID FROM Merchant INNER JOIN Person ON Merchant.MerchantID = Person.PersonID";
            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                comboBox5.Items.Add(reader["MerchantID"].ToString());
                comboBox6.Items.Add(reader["MerchantID"].ToString());
            }
            reader.Close();
        }
        private void button35_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage21;
            PopulateComboBoxMerchant();
            GetBudgetID(partnerid);

        }
        private void button33_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage6;

        }
        private void button39_Click(object sender, EventArgs e)
        {
           var con = Configuration.getInstance().getConnection();
            if (string.IsNullOrEmpty(textBox3.Text))
            {
                MessageBox.Show("Invalid or empty TimeFrame.");
                return;
            }
            if (string.IsNullOrEmpty(textBox5.Text))
            {
                MessageBox.Show("Invalid or empty BudgetName.");
                return;
            
            }
            if (string.IsNullOrEmpty(comboBox7.Text))
            {
                MessageBox.Show("Invalid or empty Type.");
                return;
            }
        
            if (string.IsNullOrEmpty(comboBox8.Text))
            {
                MessageBox.Show("Invalid or empty Budget Status.");
                return;

            }
            string budgetStatus = comboBox8.SelectedItem.ToString();
            if (budgetStatus != "Active" && budgetStatus != "Inactive")
            {
                MessageBox.Show("Invalid value for Budget Status. Please select 'Active' or 'Inactive'.");
                return;
            }
            int selectedValue = 0;
            int departmentId = 0;

            if (comboBox9.SelectedItem != null && int.TryParse(comboBox9.SelectedItem.ToString(), out selectedValue))
            {
                departmentId = selectedValue;
            }
            else
            {
                MessageBox.Show("Please select a valid integer value from the ComboBox.");
            }
            decimal totalAmount = GetTotalAmountForDepartment(departmentId);
            if (decimal.TryParse(textBox7.Text, out decimal allocatedAmount))
            {
                if (allocatedAmount >= totalAmount)
                {
                    MessageBox.Show("Allocated Amount cannot be greater than or equal to the Total Amount for the department.");
                    tabControl1.SelectedTab = tabPage25;
                    return;
                }
                SqlCommand cmd = new SqlCommand("INSERT INTO Budget (BudgetStatus, Timeframe, BudgetType, BudgetName, DepartmentID, AllocatedAmount, RemainingAmount) VALUES (@BudgetStatus, @Timeframe, @BudgetType, @BudgetName, @DepartmentID, @AllocatedAmount, @RemainingAmount)", con);

                cmd.Parameters.AddWithValue("@BudgetStatus", budgetStatus);
                cmd.Parameters.AddWithValue("@Timeframe", textBox3.Text);
                cmd.Parameters.AddWithValue("@BudgetName", textBox5.Text);
                cmd.Parameters.AddWithValue("@DepartmentID", departmentId);
                cmd.Parameters.AddWithValue("@AllocatedAmount", allocatedAmount);
                cmd.Parameters.AddWithValue("@RemainingAmount", allocatedAmount); // Assuming remaining amount initially equals allocated amount
                cmd.Parameters.AddWithValue("@BudgetType", comboBox7.SelectedItem.ToString());
                int rowsAffected = cmd.ExecuteNonQuery();
                if (rowsAffected > 0)
                {
                    MessageBox.Show("Successfully Inserted a Budget Entity.");
                    tabControl1.SelectedTab = tabPage27;
                }
                else
                {
                    MessageBox.Show("Insertion failed.");
                }
            }
            else
            {
                MessageBox.Show("Invalid datatype in Allocated Amount. Kindly enter a valid decimal number.");
                return;
            }
            ClearAllTextBoxes(this);
        }
        private void PopulateComboBoxBudget()
        {
            var con = Configuration.getInstance().getConnection();
            comboBox9.Items.Clear();
            string query = "SELECT DepartmentID FROM Department ";
            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                comboBox9.Items.Add(reader["DepartmentID"].ToString());
            }
            reader.Close();
        }
        private void button36_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage27;
        }
        private decimal GetTotalAmountForDepartment(int departmentId)
        {
            decimal totalAmount = 0;
            var con = Configuration.getInstance().getConnection();

            string query = "SELECT TotalAmount FROM Department WHERE DepartmentID = @DepartmentID";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@DepartmentID", departmentId);

            object result = cmd.ExecuteScalar();
            if (result != null && result != DBNull.Value)
            {
                totalAmount = Convert.ToDecimal(result);
            }

            return totalAmount;
        }
        private void PopulateComboBox()
        {
            var con = Configuration.getInstance().getConnection();
            comboBox10.Items.Clear();
            string query = "SELECT BudgetID FROM Budget Where BudgetStatus = 'Active' ";
            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                comboBox10.Items.Add(reader["BudgetID"].ToString());
            }
            reader.Close();
        }
        private void SoftDeleteBudget()
        {
            if (string.IsNullOrEmpty(comboBox10.Text))
            {
                MessageBox.Show("Invalid or empty ID.");
                return;
            }
            var con = Configuration.getInstance().getConnection();
            string softDeleteBudgetQuery = "UPDATE Budget SET BudgetStatus = 'Inactive' WHERE BudgetID = @BudgetID AND BudgetStatus = 'Active'";
            SqlCommand softDeleteBudgetCommand = new SqlCommand(softDeleteBudgetQuery, con);
            softDeleteBudgetCommand.Parameters.AddWithValue("@BudgetID", comboBox10.SelectedItem.ToString());
            int rowsAffected = softDeleteBudgetCommand.ExecuteNonQuery();
            if (rowsAffected > 0)
            {
                MessageBox.Show("Data deleted successfully.");
                ClearAllTextBoxes(this);
            }
            else
            {
                MessageBox.Show("No records updated. Please make sure the BudgetID is valid or Budget is Active to delete it ");
            }
        }
        private void button37_Click(object sender, EventArgs e)
        {
            SoftDeleteBudget();
            tabControl1.SelectedTab = tabPage27;
        }


        private void button45_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage25;
            PopulateComboBoxBudget();
        }

        private void button42_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage26;
            PopulateComboBox();

        }

        private void button44_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage28;
            var con = Configuration.getInstance().getConnection();
            string selectQuery = "SELECT * FROM Budget Where BudgetStatus ='Active'";
            SqlCommand command = new SqlCommand(selectQuery, con);
            SqlDataAdapter adapter = new SqlDataAdapter(command);
            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);
            dataGridView15.DataSource = dataTable;
        }
        private void button41_Click_1(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage27;
        }



        private void button47_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage27;
        }

        private void button46_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage24;

        }

        private void button48_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage27;

        }

        private void button49_Click(object sender, EventArgs e)
        {

        }

        private void button43_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage29;
            PopulateComboBoxDe();
            PopulateComboBoxUpdate();
        }
        private void PopulateComboBoxUpdate()
        {
            var con = Configuration.getInstance().getConnection();
            comboBox13.Items.Clear();
            string query = "SELECT BudgetID FROM Budget Where BudgetStatus = 'Active' ";
            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                comboBox13.Items.Add(reader["BudgetID"].ToString());
            }
            reader.Close();
        }
        private void PopulateComboBoxDe()
        {
            var con = Configuration.getInstance().getConnection();
            comboBox11.Items.Clear();
            string query = "SELECT DepartmentID FROM Department ";
            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                comboBox11.Items.Add(reader["DepartmentID"].ToString());
            }
            reader.Close();
        }

        private void submit_Click(object sender, EventArgs e)
        {
            string transactionType = comboBoxtrans.Text;

            int partnerID = partnerid;

            // Check if a merchant is selected
            if (MerchantcomboBox.SelectedItem == null)
            {
                MessageBox.Show("You cannot proceed because no merchant exists.");
                return; // Exit the method
            }
            // Check if a merchant is selected
            if (comboBoxtrans.SelectedItem == null)
            {
                MessageBox.Show("You cannot proceed without transaction type .");
                return; // Exit the method
            }
            if (comboBoxPayment.SelectedItem == null)
            {
                MessageBox.Show("You cannot proceed without transaction type .");
                return; // Exit the method
            }
            int merchantID = Convert.ToInt32(MerchantcomboBox.SelectedItem.ToString().Split('-')[0].Trim());

            bool hasInstallmentPlans = CheckInstallmentPlans(partnerID);
            string paymentMethod = comboBoxPayment.SelectedItem.ToString();

            if (hasInstallmentPlans)
            {
                ShowPendingInstallments(partnerID);
            }
            else
            {
                tabControl1.SelectedTab = tabPage36;
                txtAmount.Visible = true;
            }

            comboBoxtrans.Visible = true;
            comboBox15.Visible = true;
            button47.Visible = true;
            label61.Visible = true;
            button47.Visible = true;
            label59.Visible = false;
            label60.Visible = false;
            label95.Visible = true;
            MerchantcomboBox.Visible = false;
            comboBoxPayment.Visible = false; 
            submit.Visible = false;
            ClearAllTextBoxes(this);
        }

        private void button50_Click(object sender, EventArgs e)
        {
            // Check if a merchant is selected
            if (chequeNo.Text == null)
            {
                MessageBox.Show("Invaid Cheuq Number .");
                return; // Exit the method
            }
            if (nameBank.Text == null)
            {
                MessageBox.Show("Invaid Bank Name .");
                return; // Exit the method
            }
            string chequeNumber = chequeNo.Text;
            string bankName = nameBank.Text;
            if (!Validity.IsValidBankName(nameBank.Text))
            {
                MessageBox.Show("Please enter a valid bank name.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return; // Stop execution if bank name is invalid
            }
            if (!Validity.IsValidChequeNumber(chequeNo.Text))
            {
                MessageBox.Show("Please enter a valid cheque Number.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return; // Stop execution if bank name is invalid
            }

            string issuerName = MerchantcomboBox.SelectedItem.ToString().Split('-')[1].Trim();
            string receiverName = GetName();
            InsertIntoCheque(chequeNumber, bankName, issuerName, receiverName);
            MessageBox.Show("Cheque payment processed successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
            DisplayCheque();
            AddTransactionWithInstallmentPlan();
            MessageBox.Show("Transaction added!");
            ClearAllTextBoxes(tabPage32);
            tabControl1.SelectedTab = tabPage24;
        }

        private void button53_Click(object sender, EventArgs e)
        {
            string cardNumber = CardNo.Text;

            string bankName = BankName.Text;
            // Check if a merchant is selected
            if (CardNo.Text == null)
            {
                MessageBox.Show("Invaid Card Number .");
                return; // Exit the method
            }
            if (BankName.Text == null)
            {
                MessageBox.Show("Invaid Bank Name .");
                return; // Exit the method
            }
            if (CVV.Text == null)
            {
                MessageBox.Show("Invaid CVV Number .");
                return; // Exit the method
            }
            if (!Validity.IsValidBankName(BankName.Text))
            {
                MessageBox.Show("Please enter a valid bank name.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return; // Stop execution if bank name is invalid
            }

            if (!Validity.IsValidCardNumber(CardNo.Text))
            {
                MessageBox.Show("Card Number can only contains Digits.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            string merchantName = MerchantcomboBox.SelectedItem.ToString();
            string receiverName = GetName();
            DateTime expirationDate = dateTimePicker4.Value;
            string cvv = CVV.Text;
            string transactionReference = TransRef.Text;
            InsertIntoCreditCard(cardNumber, bankName, merchantName, receiverName, expirationDate, cvv, transactionReference);
            MessageBox.Show("Credit card payment processed successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
            DisplayCard();
            AddTransactionWithInstallmentPlan();
            MessageBox.Show("Transaction added!");
            ClearAllTextBoxes(tabPage33);
            tabControl1.SelectedTab = tabPage24;
        }

        private void button55_Click(object sender, EventArgs e)
        {
            if (BankName.Text == null)
            {
                MessageBox.Show("Invaid Name of Bank.");
                return; // Exit the method
            }
            if (AccNum.Text == null)
            {
                MessageBox.Show("Invaid Name of Bank.");
                return; // Exit the method
            }
            string bankName = NameOfBank.Text;
            if (!Validity.IsValidBankName(NameOfBank.Text))
            {
                MessageBox.Show("Please enter a valid bank name.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return; // Stop execution if bank name is invalid
            }
            if (!Validity.IsValidAccountNumber(AccNum.Text))
            {
                MessageBox.Show("Please enter a valid Account Number.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return; // Stop execution if bank name is invalid
            }


                string accountNumber = AccNum.Text;
            string transactionReference = TransRefer.Text;
            string senderName = MerchantcomboBox.SelectedItem.ToString();
            string receiverName = GetName();
            InsertIntoOnlines(bankName, accountNumber, transactionReference, senderName, receiverName);
            MessageBox.Show("Online payment processed successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
            DisplayOnline();
            AddTransactionWithInstallmentPlan();
            MessageBox.Show("Transaction added!");
            ClearAllTextBoxes(tabPage34);
            tabControl1.SelectedTab = tabPage24;
        }

        private void button58_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage37;
        }

        private void button57_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage36;

        }

        private void button59_Click(object sender, EventArgs e)
        {
            decimal Amount = Convert.ToDecimal(txtAmount.Text);
            decimal amount = Amount;
            CompareWithdrawalThresholdWithAmount(partnerid, amount);
        }

        private void button60_Click(object sender, EventArgs e)
        {
            decimal Amount = Convert.ToDecimal(comboBox14.SelectedItem);
            decimal amount = Amount;
            tabControl1.SelectedTab = tabPage38;
            CheckPayment();
        }
        private void button62_Click(object sender, EventArgs e)
        {
            if (ChequeNum.Text == null)
            {
                MessageBox.Show("Invaid Chque Number .");
                return; // Exit the method
            }

            string chequeNumber = ChequeNum.Text;
            string bankName = BankNam.Text;
            if (!Validity.IsValidBankName(BankNam.Text))
            {
                MessageBox.Show("Please enter a valid bank name.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return; // Stop execution if bank name is invalid
            }
            if (!Validity.IsValidChequeNumber(chequeNo.Text))
            {
                MessageBox.Show("Please enter a valid cheque Number.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return; // Stop execution if bank name is invalid
            }
            string issuerName = MerchantcomboBox.SelectedItem.ToString().Split('-')[1].Trim();
            string receiverName = GetName();
            InsertIntoCheque(chequeNumber, bankName, issuerName, receiverName);
            MessageBox.Show("Cheque payment processed successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
            ChequeDisplay();
            AddTransaction();
            MessageBox.Show("Transaction added!");
            ClearAllTextBoxes(tabPage39);
            tabControl1.SelectedTab = tabPage24;
        }
        private void button64_Click(object sender, EventArgs e)
        {
           
            string cardNumber = NumbCard.Text;
            string bankName = NaamBank.Text;
            if(!Validity.IsValidBankName(NaamBank.Text))
            {
                MessageBox.Show("Please enter a valid bank name.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return; // Stop execution if bank name is invalid
            }
            if (!Validity.IsValidCardNumber(CardNo.Text))
            {
                MessageBox.Show("Card Number can only contains Digits.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            string merchantName = MerchantcomboBox.SelectedItem.ToString();
            string receiverName = GetName();
            DateTime expirationDate = dateTimePicker5.Value;
            string cvv = Cvvv.Text;
            string transactionReference = RefTrans.Text;
            InsertIntoCreditCard(cardNumber, bankName, merchantName, receiverName, expirationDate, cvv, transactionReference);
            MessageBox.Show("Credit card payment processed successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
            CardDisplay();
            AddTransaction();
            MessageBox.Show("Transaction added!");
            ClearAllTextBoxes(tabPage40);
            tabControl1.SelectedTab = tabPage24;
        }

        private void button66_Click(object sender, EventArgs e)
        {
            string bankName = NameBankk.Text;
            if (!Validity.IsValidBankName(NameBankk.Text))
            {
                MessageBox.Show("Please enter a valid bank name.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return; // Stop execution if bank name is invalid
            }
             if (!Validity.IsValidAccountNumber(AccNum.Text))
            {
                MessageBox.Show("Please enter a valid Account Number.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return; // Stop execution if bank name is invalid
            }
            string accountNumber = AccountNum.Text;
            string transactionReference = ReferTransc.Text;
            string senderName = MerchantcomboBox.SelectedItem.ToString();
            string receiverName = GetName();
            InsertIntoOnlines(bankName, accountNumber, transactionReference, senderName, receiverName);
            MessageBox.Show("Online payment processed successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
            DisplayOnlines();
            AddTransaction();
            MessageBox.Show("Transaction added!");
            ClearAllTextBoxes(tabPage41);
            tabControl1.SelectedTab = tabPage24;
        }
        private bool CheckInstallmentPlans(int partnerID)
        {
            var con = Configuration.getInstance().getConnection();
                string query = @"
            SELECT i.InstallmentID, i.InstallmentPlanID, i.TransactionID, i.InstallmentNumber, 
            i.TotalAmount, i.PaidAmount, i.DueDate, i.PaymentStatus
            FROM Installments i
            INNER JOIN InstallmentPlan ip ON i.InstallmentPlanID = ip.InstallmentPlanID
            WHERE ip.PartnerID = @PartnerID AND ip.MerchantID = @MerchantID AND i.PaymentStatus = 'Pending';";
                int merchantID = Convert.ToInt32(MerchantcomboBox.SelectedItem.ToString().Split('-')[0].Trim());
                SqlCommand command = new SqlCommand(query, con);
                command.Parameters.AddWithValue("@PartnerID", partnerID);
                command.Parameters.AddWithValue("@MerchantID", merchantID);
                object result = command.ExecuteScalar();
                return result != null;
        }
        public void ShowPendingInstallments(int partnerID)
        {
            tabControl1.SelectedTab = tabPage35;
            SqlConnection con = Configuration.getInstance().getConnection();
                    int merchantID = Convert.ToInt32(MerchantcomboBox.SelectedItem.ToString().Split('-')[0].Trim());
                    string query = @"
                SELECT i.InstallmentID, i.InstallmentPlanID, i.TransactionID, i.InstallmentNumber, 
                i.TotalAmount, i.PaidAmount, i.DueDate, i.PaymentStatus
                FROM Installments i
                INNER JOIN InstallmentPlan ip ON i.InstallmentPlanID = ip.InstallmentPlanID
                WHERE ip.PartnerID = @PartnerID AND ip.MerchantID = @MerchantID AND i.PaymentStatus = 'Pending';";
                    SqlCommand command = new SqlCommand(query, con);
                    command.Parameters.AddWithValue("@PartnerID", partnerID);
                    command.Parameters.AddWithValue("@MerchantID", merchantID);
                    SqlDataReader reader = command.ExecuteReader();
                    DataTable dataTable = new DataTable();
                    dataTable.Load(reader);
                    dataGridView19.DataSource = dataTable;
                    comboBox14.Items.Clear();
                    foreach (DataRow row in dataTable.Rows)
                    {
                        decimal paidAmount = Convert.ToDecimal(row["PaidAmount"]);
                        comboBox14.Items.Add(paidAmount);
                    }
        }

        public void CheckPaymentProcessed()
        {
            if (comboBoxPayment.SelectedItem == null)
            {
                MessageBox.Show("Please select a payment method.", "Payment Method Required", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            else if (comboBoxPayment.SelectedItem.ToString() == "Cheque")
            {
                tabControl3.SelectedTab = tabPage32;
            }
            else if (comboBoxPayment.SelectedItem.ToString() == "Credit Card")
            {
                tabControl3.SelectedTab = tabPage33;
            }
            else if (comboBoxPayment.SelectedItem.ToString() == "Online")
            {
                tabControl3.SelectedTab = tabPage34;
            }
            else
            {
                MessageBox.Show("Please select a valid payment method.", "Invalid Payment Method", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            return;
        }
        private int GetWithdrawalThreshold(int partnerID)
        {
            int withdrawalThreshold = 0;
            var con = Configuration.getInstance().getConnection();
            string query = "SELECT WithdrawalThreshold FROM Partner WHERE PartnerID = @PartnerID";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@PartnerID", partnerID);

            object result = cmd.ExecuteScalar();
            if (result != null)
            {
                withdrawalThreshold = Convert.ToInt32(result);
            }
            return withdrawalThreshold;
        }
        private void InsertInstallment(int partnerID, decimal paidAmunt, decimal totalAmount, DateTime dueDate, int insatllmentNumber)
        {
            var con = Configuration.getInstance().getConnection();
            string insertQuery = @"INSERT INTO Installments (InstallmentPlanID, InstallmentNumber ,TotalAmount,PaidAmount,  DueDate, PaymentStatus)
                           VALUES (@InstallmentPlanID, @InstallmentNumber , @TotalAmount,@PaidAmount ,  @DueDate, @PaymentStatus)";
            SqlCommand command = new SqlCommand(insertQuery, con);
            command.Parameters.AddWithValue("@InstallmentPlanID", partnerID);
            command.Parameters.AddWithValue("@InstallmentNumber", insatllmentNumber);
            command.Parameters.AddWithValue("@TotalAmount", totalAmount);
            command.Parameters.AddWithValue("@PaidAmount", paidAmunt);

            command.Parameters.AddWithValue("@DueDate", dueDate);
            command.Parameters.AddWithValue("@PaymentStatus", "Pending");
            command.ExecuteNonQuery();
        }
        private void CompareWithdrawalThresholdWithAmount(int partnerID, decimal amount)
        {
            int withdrawalThreshold = GetWithdrawalThreshold(partnerID);
            if (amount > withdrawalThreshold)
            {
                MessageBox.Show("Installment plan needs to be implemented.", "Installment Plan", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                label1.Visible = true;
                comboBoxPayment.Visible = true;
                maxInstallments = CalculateMaxInstallments(withdrawalThreshold, amount);
                List<decimal> installmentAmounts = DivideAmountIntoInstallments(amount, maxInstallments, withdrawalThreshold);
                int merchantID = Convert.ToInt32(MerchantcomboBox.SelectedItem.ToString().Split('-')[0].Trim());
                partnerID = partnerid;
                StringBuilder sb = new StringBuilder();
                DateTime currentDate = DateTime.Now;
                DateTime firstDueDate = currentDate.AddMonths(1);
                DateTime laterDueDate = currentDate.AddMonths(2);
                int installmentPlanId = InsertIntoInstallmentPlan(merchantID, partnerID, maxInstallments);
                for (int i = 0; i < maxInstallments; i++)
                {
                    DateTime dueDate = i == 0 ? firstDueDate : laterDueDate;
                    InsertInstallment(installmentPlanId, installmentAmounts[i], amount, dueDate, i + 1);
                    sb.AppendLine($"Installment {i + 1}: {installmentAmounts[i].ToString("C")}");
                }
                MessageBox.Show(sb.ToString(), "Installment Amounts", MessageBoxButtons.OK, MessageBoxIcon.Information);
                MessageBox.Show("Installments added successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                tabControl1.SelectedTab = tabPage30;
            }
            else
            {
                MessageBox.Show("No installment plan is needed. Proceed with payment method selection.", "Payment Method Selection", MessageBoxButtons.OK, MessageBoxIcon.Information);
                tabControl1.SelectedTab = tabPage31;
                CheckPaymentProcessed();
            }
        }
        private int CalculateMaxInstallments(int withdrawalThreshold, decimal amount)
        {
            int maxInstallments = (int)Math.Ceiling(amount / withdrawalThreshold);
            maxInstallments = Math.Min(maxInstallments, 3);
            return maxInstallments;
        }
        private int InsertIntoInstallmentPlan(int merchantID, int partnerID, int numInstallments)
        {
            var con = Configuration.getInstance().getConnection();
            string query = "INSERT INTO InstallmentPlan (PartnerID, MerchantID, MaxInstallments) VALUES (@PartnerID, @MerchantID, @MaxInstallments); SELECT SCOPE_IDENTITY();";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@PartnerID", partnerID);
            cmd.Parameters.AddWithValue("@MerchantID", merchantID);
            cmd.Parameters.AddWithValue("@MaxInstallments", numInstallments);
            int installmentPlanID = Convert.ToInt32(cmd.ExecuteScalar());
            return installmentPlanID;

        }
        private List<decimal> DivideAmountIntoInstallments(decimal totalAmount, int maxInstallments, int withdrawalThreshold)
        {
            List<decimal> installments = new List<decimal>();
            decimal baseInstallmentAmount = totalAmount / maxInstallments;
            decimal remainder = totalAmount % maxInstallments;
            decimal adjustedInstallmentAmount = baseInstallmentAmount + (remainder / maxInstallments);
            for (int i = 0; i < maxInstallments; i++)
            {
                installments.Add(adjustedInstallmentAmount);
            }

            return installments;
        }
        private int InsertIntoCheque(string chequeNumber, string bankName, string issuerName, string receiverName)
        {
            var con = Configuration.getInstance().getConnection();
            int merchantID = Convert.ToInt32(MerchantcomboBox.SelectedItem.ToString().Split('-')[0].Trim());
            int partnerID = partnerid;
            string chequeQuery = "INSERT INTO Cheque (ChequeNumber, BankName, IssuerName, ReceiverName) " +
                                 "VALUES (@ChequeNumber, @BankName, @IssuerName, @ReceiverName); " +
                                 "SELECT SCOPE_IDENTITY()";
            SqlCommand chequeCmd = new SqlCommand(chequeQuery, con);
            chequeCmd.Parameters.AddWithValue("@ChequeNumber", chequeNumber);
            chequeCmd.Parameters.AddWithValue("@BankName", bankName);
            chequeCmd.Parameters.AddWithValue("@IssuerName", issuerName);
            chequeCmd.Parameters.AddWithValue("@ReceiverName", receiverName);

            int paymentMethodID = Convert.ToInt32(chequeCmd.ExecuteScalar());

            int chequeID = Convert.ToInt32(chequeCmd.ExecuteScalar());
            string insertPaymentMethodQuery = @"INSERT INTO PaymentMethod (ChequeID, MerchantID, PartnerID, OnlineID, CreditCardID, PaymentType) 
                            VALUES (@ChequeID, @MerchantID, @PartnerID, NULL, NULL, @PaymentType)";
            SqlCommand cmdInsertPaymentMethod = new SqlCommand(insertPaymentMethodQuery, con);
            cmdInsertPaymentMethod.Parameters.AddWithValue("@ChequeID", chequeID);
            cmdInsertPaymentMethod.Parameters.AddWithValue("@MerchantID", merchantID);
            cmdInsertPaymentMethod.Parameters.AddWithValue("@PartnerID", partnerID);
            cmdInsertPaymentMethod.Parameters.AddWithValue("@PaymentType", "Cheque");
            cmdInsertPaymentMethod.ExecuteNonQuery();
            return paymentMethodID;
        }
        private void AddTransactionWithInstallmentPlan()
        {
            int merchantID = Convert.ToInt32(MerchantcomboBox.SelectedItem.ToString().Split('-')[0].Trim());
            int partnerID = partnerid;
            int installmentPlanID = InsertIntoInstallmentPlan(merchantID, partnerID, maxInstallments);
            int paymentMethodID = GetPaymentMethodID();
            string transactionType = comboBoxtrans.Text;
            decimal amount = Convert.ToDecimal(txtAmount.Text);
            InsertIntoTransaction(amount, transactionType, paymentMethodID, installmentPlanID);
            MessageBox.Show("Transaction added successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        private string GetName()
        {
            string firstName = null;
            var con = Configuration.getInstance().getConnection();

            string query = "SELECT p.FirstName FROM Partner pa INNER JOIN Person p ON pa.PartnerID = p.PersonID WHERE pa.PartnerID = @PartnerID;";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@PartnerID", partnerid);
            object result = cmd.ExecuteScalar();
            if (result != null)
            {
                firstName = result.ToString();
            }
            return firstName;
        }
        private int InsertIntoCreditCard(string cardNumber, string bankName, string merchantName, string receiverName, DateTime expirationDate, string cvv, string transactionReference)
        {

            var con = Configuration.getInstance().getConnection();
            int merchantID = Convert.ToInt32(MerchantcomboBox.SelectedItem.ToString().Split('-')[0].Trim());
            int partnerID = partnerid;
            string creditCardQuery = "INSERT INTO CreditCard (CardNumber, BankName, CardHolderName, ReceiverName, ExpiryDate, CVV, TransactionReference) " +
                                     "VALUES (@CardNumber, @BankName, @MerchantName, @ReceiverName, @ExpiryDate, @CVV, @TransactionReference); " +
                                     "SELECT SCOPE_IDENTITY()";
            SqlCommand creditCardCmd = new SqlCommand(creditCardQuery, con);
            creditCardCmd.Parameters.AddWithValue("@CardNumber", cardNumber);
            creditCardCmd.Parameters.AddWithValue("@BankName", bankName);
            creditCardCmd.Parameters.AddWithValue("@MerchantName", merchantName);
            creditCardCmd.Parameters.AddWithValue("@ReceiverName", receiverName);
            creditCardCmd.Parameters.AddWithValue("@ExpiryDate", expirationDate);
            creditCardCmd.Parameters.AddWithValue("@CVV", cvv);
            creditCardCmd.Parameters.AddWithValue("@TransactionReference", transactionReference);
            int creditCardID = Convert.ToInt32(creditCardCmd.ExecuteScalar());
            int paymentMethodID = Convert.ToInt32(creditCardCmd.ExecuteScalar());
            string insertPaymentMethodQuery = @"INSERT INTO PaymentMethod (ChequeID, MerchantID, PartnerID, OnlineID, CreditCardID, PaymentType) 
                VALUES (NULL, @MerchantID, @PartnerID, NULL, @CreditCardID, @PaymentType)";
            SqlCommand cmdInsertPaymentMethod = new SqlCommand(insertPaymentMethodQuery, con);
            cmdInsertPaymentMethod.Parameters.AddWithValue("@MerchantID", merchantID);
            cmdInsertPaymentMethod.Parameters.AddWithValue("@PartnerID", partnerID);
            cmdInsertPaymentMethod.Parameters.AddWithValue("@CreditCardID", creditCardID);
            cmdInsertPaymentMethod.Parameters.AddWithValue("@PaymentType", "Credit Card");
            cmdInsertPaymentMethod.ExecuteNonQuery();
            return paymentMethodID;
        }
        private int InsertIntoOnlines(string bankName, string accountNumber, string transactionReference, string senderName, string receiverName)
        {
            var con = Configuration.getInstance().getConnection();
            int merchantID = Convert.ToInt32(MerchantcomboBox.SelectedItem.ToString().Split('-')[0].Trim());
            int partnerID = partnerid;
            string onlineQuery = "INSERT INTO Onlines (BankName, AccountNumber, TransactionReference, SenderName, ReceiverName) " +
                                 "VALUES (@BankName, @AccountNumber, @TransactionReference, @SenderName, @ReceiverName); " +
                                 "SELECT SCOPE_IDENTITY()";
            SqlCommand onlineCmd = new SqlCommand(onlineQuery, con);
            onlineCmd.Parameters.AddWithValue("@BankName", bankName);
            onlineCmd.Parameters.AddWithValue("@AccountNumber", accountNumber);
            onlineCmd.Parameters.AddWithValue("@TransactionReference", transactionReference);
            onlineCmd.Parameters.AddWithValue("@SenderName", senderName);
            onlineCmd.Parameters.AddWithValue("@ReceiverName", receiverName);

            int onlineID = Convert.ToInt32(onlineCmd.ExecuteScalar());
            int paymentMethodID = Convert.ToInt32(onlineCmd.ExecuteScalar());
            string insertPaymentMethodQuery = @"INSERT INTO PaymentMethod (ChequeID, MerchantID, PartnerID, OnlineID, CreditCardID, PaymentType) 
        VALUES (NULL, @MerchantID, @PartnerID, @OnlineID, NULL, @PaymentType)";
            SqlCommand cmdInsertPaymentMethod = new SqlCommand(insertPaymentMethodQuery, con);
            cmdInsertPaymentMethod.Parameters.AddWithValue("@MerchantID", merchantID);
            cmdInsertPaymentMethod.Parameters.AddWithValue("@PartnerID", partnerID);
            cmdInsertPaymentMethod.Parameters.AddWithValue("@OnlineID", onlineID);
            cmdInsertPaymentMethod.Parameters.AddWithValue("@PaymentType", "Online");
            cmdInsertPaymentMethod.ExecuteNonQuery();
            return paymentMethodID;
        }
        public void GetBudgetID(int partnerID)
        {
            var con = Configuration.getInstance().getConnection();
            string departmentQuery = "SELECT DepartmentID FROM Partner WHERE PartnerID = @PartnerID";
            SqlCommand cmd = new SqlCommand(departmentQuery, con);
            cmd.Parameters.AddWithValue("@PartnerID", partnerID);
            object departmentIDObj = cmd.ExecuteScalar();

            if (departmentIDObj != null && departmentIDObj != DBNull.Value)
            {
                int departmentID = Convert.ToInt32(departmentIDObj);

                string budgetQuery = "SELECT BudgetID FROM Budget WHERE DepartmentID = @DepartmentID";
                SqlCommand budgetCmd = new SqlCommand(budgetQuery, con);
                budgetCmd.Parameters.AddWithValue("@DepartmentID", departmentID);

                SqlDataReader reader = budgetCmd.ExecuteReader();
                if (!reader.HasRows)
                {
                    MessageBox.Show("No records found for the given department ID.");
                    return; // Exit the method if no records are found
                }
                while (reader.Read())
                {
                    comboBox15.Items.Add(reader["BudgetID"].ToString());
                }
                reader.Close();
            }
        }
        private void InsertIntoTransaction(decimal amount, string transactionType, int paymentMethodID, int installmentPlanID)
        {
            var con = Configuration.getInstance().getConnection();
            int partnerID = partnerid;
            int budgetID = int.Parse(comboBox15.SelectedItem.ToString());
            string query = @"
        INSERT INTO Transactions (Amount, TransactionType, PaymentMethodID, InstallmentPlanID, BudgetID, Date) 
        VALUES (@Amount, @TransactionType, @PaymentMethodID, @InstallmentPlanID, @BudgetID, @Date);
        SELECT SCOPE_IDENTITY();";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Amount", amount);
            cmd.Parameters.AddWithValue("@TransactionType", transactionType);
            cmd.Parameters.AddWithValue("@PaymentMethodID", paymentMethodID);
            cmd.Parameters.AddWithValue("@InstallmentPlanID", installmentPlanID);
            cmd.Parameters.AddWithValue("@BudgetID", budgetID);
            cmd.Parameters.AddWithValue("@Date", DateTime.Now);
            cmd.ExecuteNonQuery();
            int transactionID = transactionId;
        }


        private int GetPaymentMethodID()
        {
            string selectedPaymentMethod = comboBoxPayment.SelectedItem.ToString();
            var con = Configuration.getInstance().getConnection();
            string query = "SELECT MAX(PaymentMethodID) FROM PaymentMethod WHERE PaymentType = @PaymentType";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@PaymentType", selectedPaymentMethod);
            int paymentMethodID = Convert.ToInt32(cmd.ExecuteScalar());
            return paymentMethodID;
        }
        private int InsertTransaction(decimal amount, string transactionType, int paymentMethodID, int installmentPlanID)
        {
            var con = Configuration.getInstance().getConnection();
            int partnerID = partnerid;
            int budgetID = int.Parse(comboBox15.SelectedItem.ToString());
            decimal remainingAmount = GetCurrentAmount(budgetID); 

            if (transactionType == "Expense" && amount > remainingAmount)
            {
                MessageBox.Show("Amount exceeds the remaining budget. Please enter a valid amount.");
                return -1; 
            }

            string query = @"
        INSERT INTO Transactions (Amount, TransactionType, PaymentMethodID, InstallmentPlanID, BudgetID, Date) 
        VALUES (@Amount, @TransactionType, @PaymentMethodID, @InstallmentPlanID, @BudgetID, @Date);
        SELECT SCOPE_IDENTITY();";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Amount", amount);
            cmd.Parameters.AddWithValue("@TransactionType", transactionType);
            cmd.Parameters.AddWithValue("@PaymentMethodID", paymentMethodID);
            cmd.Parameters.AddWithValue("@InstallmentPlanID", installmentPlanID);
            cmd.Parameters.AddWithValue("@BudgetID", budgetID);
            cmd.Parameters.AddWithValue("@Date", DateTime.Now);
            int transactionID = -1; 
            try
            {
                transactionID = Convert.ToInt32(cmd.ExecuteScalar());
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error inserting transaction: " + ex.Message);
            }
          
            return transactionID;
        }

        private void AddTransaction()
        {
            int merchantID = Convert.ToInt32(MerchantcomboBox.SelectedItem.ToString().Split('-')[0].Trim());
            int partnerID = partnerid;
            decimal amount = Convert.ToDecimal(comboBox14.SelectedItem);
            int installmentPlanID = GetInstallmentPlanID(amount, partnerID);
            int paymentMethodID = GetPaymentMethodID();
            string transactionType = comboBoxtrans.Text;
            int transactionID = InsertTransaction(amount, transactionType, paymentMethodID, installmentPlanID);
            UpdateInstallmentStatus(installmentPlanID, transactionID);
            MessageBox.Show("Transaction added successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void UpdateInstallmentStatus(int installmentPlanID, int transactionID)
        {
            var con = Configuration.getInstance().getConnection();
            string query = @"
        UPDATE Installments 
        SET PaymentStatus = 'Paid', TransactionID = @TransactionID 
        WHERE InstallmentPlanID = @InstallmentPlanID 
        AND PaymentStatus = 'Pending' 
        AND (InstallmentNumber = (
            SELECT TOP 1 InstallmentNumber 
            FROM Installments 
            WHERE InstallmentPlanID = @InstallmentPlanID 
            AND PaymentStatus = 'Pending' 
            ORDER BY InstallmentNumber ASC
        ))";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@TransactionID", transactionID);
            cmd.Parameters.AddWithValue("@InstallmentPlanID", installmentPlanID);
            cmd.ExecuteNonQuery();
        }


        public int GetInstallmentPlanID(decimal selectedAmount, int partnerID)
        {
            int installmentPlanID = -1; // Default value if installment plan ID is not found

            var con = Configuration.getInstance().getConnection();
            string query = @"
        SELECT TOP 1 i.InstallmentPlanID
        FROM Installments i
        INNER JOIN InstallmentPlan ip ON i.InstallmentPlanID = ip.InstallmentPlanID
        WHERE ip.PartnerID = @PartnerID AND i.PaidAmount = @SelectedAmount AND i.PaymentStatus = 'Pending';";

            SqlCommand command = new SqlCommand(query, con);
            command.Parameters.AddWithValue("@PartnerID", partnerID);
            command.Parameters.AddWithValue("@SelectedAmount", selectedAmount);

            object result = command.ExecuteScalar();
            if (result != null && result != DBNull.Value)
            {
                installmentPlanID = Convert.ToInt32(result);
            }

            return installmentPlanID;
        }
        public void CheckPayment()
        {
            if (comboBoxPayment.SelectedItem == null)
            {
                MessageBox.Show("Please select a payment method.", "Payment Method Required", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            else if (comboBoxPayment.SelectedItem.ToString() == "Cheque")
            {
                tabControl4.SelectedTab = tabPage39;
            }
            else if (comboBoxPayment.SelectedItem.ToString() == "Credit Card")
            {
                tabControl4.SelectedTab = tabPage40;
            }
            else if (comboBoxPayment.SelectedItem.ToString() == "Online")
            {
                tabControl4.SelectedTab = tabPage41;
            }
            else
            {
                MessageBox.Show("Please select a valid payment method.", "Invalid Payment Method", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            return;
        }

        private void button56_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage30;
        }

        private void button34_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage30;
            GetBudgetID(partnerid);

        }
        private void PopulateCombo()
        {
            var con = Configuration.getInstance().getConnection();
            MerchantcomboBox.Items.Clear();
            if(comboBoxtrans.SelectedItem == "Expense")
            {
                string query = "SELECT MerchantID, CONCAT(MerchantID, ' - ', FirstName, ' ', LastName) AS DisplayText FROM Merchant INNER JOIN Person ON" +
                    " Merchant.MerchantID = Person.PersonID WHERE MerchantType = 'Sale' AND PartnerID = @PartnerID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@PartnerID", partnerid);

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {

                    MerchantcomboBox.Items.Add(reader["DisplayText"].ToString());

                }
                reader.Close();
            }
            else
            {
                string query = "SELECT MerchantID, CONCAT(MerchantID, ' - ', FirstName, ' ', LastName) AS DisplayText FROM Merchant INNER JOIN Person ON" +
                  " Merchant.MerchantID = Person.PersonID WHERE MerchantType = 'Purchase'";
                SqlCommand cmd = new SqlCommand(query, con);
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {

                    MerchantcomboBox.Items.Add(reader["DisplayText"].ToString());

                }
                reader.Close();
            }
           
        }
        private void DisplayCard()
        {
            //dataGridView17.Rows.Clear(); // Clear existing data
            var con = Configuration.getInstance().getConnection();
            string query = @"
        SELECT c.CardNumber, c.BankName, c.CardHolderName, c.ExpiryDate, c.CVV, c.TransactionReference, t.Amount
        FROM CreditCard c
        INNER JOIN PaymentMethod pm ON c.CreditCardID = pm.CreditCardID
        INNER JOIN Transactions t ON pm.PaymentMethodID = t.PaymentMethodID";
            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);
            dataGridView17.DataSource = dataTable;
        }
        private void button52_Click(object sender, EventArgs e)
        {
            DisplayCard();

        }
        private void DisplayOnline()
        {
            //dataGridView18.Rows.Clear();
            var con = Configuration.getInstance().getConnection();
            string query = @"
        SELECT  c.BankName, c.AccountNumber , c.TransactionReference, t.Amount
        FROM Onlines c
        INNER JOIN PaymentMethod pm ON c.OnlineID = pm.OnlineID
        INNER JOIN Transactions t ON pm.PaymentMethodID = t.PaymentMethodID";

            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);
            dataGridView18.DataSource = dataTable;
        }

        private void button54_Click(object sender, EventArgs e)
        {
            DisplayOnline();
        }

        private void dataGridView16_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
        private void DisplayCheque()
        {
           // dataGridView16.Rows.Clear();
            var con = Configuration.getInstance().getConnection();
            string query = @"
        SELECT c.ChequeNumber, c.BankName, c.IssuerName, t.Amount
        FROM Cheque c
        INNER JOIN PaymentMethod pm ON c.ChequeID = pm.ChequeID
        INNER JOIN Transactions t ON pm.PaymentMethodID = t.PaymentMethodID";

            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);
            dataGridView16.DataSource = dataTable;
        }

        private void button38_Click(object sender, EventArgs e)
        {
            DisplayCheque();
        }
        private void ChequeDisplay()
        {
          // dataGridView20.Rows.Clear();
            var con = Configuration.getInstance().getConnection();
            string query = @"
        SELECT c.ChequeNumber, c.BankName, c.IssuerName, t.Amount
        FROM Cheque c
        INNER JOIN PaymentMethod pm ON c.ChequeID = pm.ChequeID
        INNER JOIN Transactions t ON pm.PaymentMethodID = t.PaymentMethodID";

            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);
            dataGridView20.DataSource = dataTable;
        }
        private void button61_Click(object sender, EventArgs e)
        {
            ChequeDisplay();
        }

        private void CardDisplay()
        {
            //dataGridView21.Rows.Clear(); // Clear existing data
            var con = Configuration.getInstance().getConnection();
            string query = @"
        SELECT c.CardNumber, c.BankName, c.CardHolderName, c.ExpiryDate, c.CVV, c.TransactionReference, t.Amount
        FROM CreditCard c
        INNER JOIN PaymentMethod pm ON c.CreditCardID = pm.CreditCardID
        INNER JOIN Transactions t ON pm.PaymentMethodID = t.PaymentMethodID";
            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);
            dataGridView21.DataSource = dataTable;
        }
        private void button63_Click(object sender, EventArgs e)
        {
            CardDisplay();
        }
        private void DisplayOnlines()
        {
           // dataGridView22.Rows.Clear();
            var con = Configuration.getInstance().getConnection();
            string query = @"
        SELECT  c.BankName, c.AccountNumber , c.TransactionReference, t.Amount
        FROM Onlines c
        INNER JOIN PaymentMethod pm ON c.OnlineID = pm.OnlineID
        INNER JOIN Transactions t ON pm.PaymentMethodID = t.PaymentMethodID";

            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable dataTable = new DataTable();
            adapter.Fill(dataTable);
            dataGridView22.DataSource = dataTable;
        }
        private void button65_Click(object sender, EventArgs e)
        {
            DisplayOnlines();  
        }

        private void button67_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage30;
        }

        private void button68_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage30;
        }

        private void label92_Click(object sender, EventArgs e)
        {

        }
        public void PopulateExistingData(int registrationNumber)
        {
            var con = Configuration.getInstance().getConnection();

            using (SqlCommand command = new SqlCommand("SELECT BudgetName ,BudgetType , TimeFrame , AllocatedAmount ,DepartmentID  FROM Budget WHERe BudgetID  = @BudgetID", con))
            {
                command.Parameters.AddWithValue("@BudgetID", registrationNumber);
                SqlDataReader reader = command.ExecuteReader();
                if (reader.Read())
                {
                    textBox6.Text = reader["TimeFrame"].ToString();
                    textBox4.Text = reader["BudgetName"].ToString();
                    comboBox12.SelectedItem = reader["BudgetType"].ToString();
                    comboBox11.SelectedItem = reader["DepartmentID"].ToString();
                    textBox2.Text = reader["AllocatedAmount"].ToString();

                    reader.Close();
                }
                else
                {
                    MessageBox.Show("No record found for the provided BudgetID .");
                    reader.Close();
                }
            }
        }
        private void button40_Click_1(object sender, EventArgs e)
        {
            label57.Visible = false;
            comboBox13.Visible = false;
            int budget = int.Parse(comboBox13.SelectedItem.ToString());
            button40.Visible = false;
            panel6.Visible = true;
            PopulateExistingData(budget);
        }

        private void panel6_Paint(object sender, PaintEventArgs e)
        {

        }

        private void button49_Click_1(object sender, EventArgs e)
        {
            var con = Configuration.getInstance().getConnection();
            string budgetStatus = comboBox13.SelectedItem.ToString();
            if (string.IsNullOrEmpty(textBox6.Text))
            {
                MessageBox.Show("Invalid or empty TimeFrame.");
                return;
            }
            if (string.IsNullOrEmpty(textBox4.Text))
            {
                MessageBox.Show("Invalid or empty Name.");
                return;
            }
            if (string.IsNullOrEmpty(comboBox12.Text))
            {
                MessageBox.Show("Invalid or empty Type.");
                return;
            }
            int selectedValue = 0;
            int departmentId = 0;
            decimal remainingAmount = 0;
            if (comboBox11.SelectedItem != null && int.TryParse(comboBox11.SelectedItem.ToString(), out selectedValue))
            {
                departmentId = selectedValue;
            }
            else
            {
                MessageBox.Show("Please select a valid integer value from the ComboBox.");
            }
            decimal totalAmount = GetTotalAmountForDepartment(departmentId);
            if (decimal.TryParse(textBox2.Text, out decimal allocatedAmount))
            {
                if (allocatedAmount >= totalAmount)
                {
                    MessageBox.Show("Allocated Amount cannot be greater than or equal to the Total Amount for the department.");
                    tabControl1.SelectedTab = tabPage25;
                    return;
                }
                decimal currentRemainingAmount = GetCurrentRemainingAmount(budgetStatus);
                if (currentRemainingAmount == allocatedAmount)
                {
                    remainingAmount = allocatedAmount;
                }
                else
                {
                    remainingAmount = currentRemainingAmount + allocatedAmount;
                }
                SqlCommand cmd = new SqlCommand("UPDATE [dbo].[Budget] SET Timeframe = @Timeframe, BudgetType = @BudgetType, BudgetName = @BudgetName, DepartmentID=@DepartmentID,AllocatedAmount=@AllocatedAmount,RemainingAmount=@RemainingAmount WHERE [BudgetID] = @BudgetID", con);
                cmd.Parameters.AddWithValue("@BudgetID", budgetStatus);
                cmd.Parameters.AddWithValue("@Timeframe", textBox6.Text);
                cmd.Parameters.AddWithValue("@BudgetName", textBox4.Text);
                cmd.Parameters.AddWithValue("@DepartmentID", departmentId);
                cmd.Parameters.AddWithValue("@AllocatedAmount", allocatedAmount);
                cmd.Parameters.AddWithValue("@RemainingAmount", remainingAmount);
                cmd.Parameters.AddWithValue("@BudgetType", comboBox12.SelectedItem.ToString());
                cmd.ExecuteNonQuery();
                int rowsAffected = cmd.ExecuteNonQuery();
                if (rowsAffected > 0)
                {
                    MessageBox.Show("Successfully Inserted a Budget Entity.");
                    tabControl1.SelectedTab = tabPage27;
                }
                else
                {
                    MessageBox.Show("Insertion failed.");
                }
            }
            else
            {
                MessageBox.Show("Invalid datatype in Allocated Amount. Kindly enter a valid decimal number.");
                return;
            }
            ClearAllTextBoxes(this);
        }
        private decimal GetCurrentRemainingAmount(string budgetStatus)
        {
            decimal remainingAmount = 0;
            var con = Configuration.getInstance().getConnection();
            SqlCommand cmd = new SqlCommand("SELECT RemainingAmount FROM Budget WHERE BudgetID = @BudgetID", con);
            cmd.Parameters.AddWithValue("@BudgetID", budgetStatus);
            object result = cmd.ExecuteScalar();
            if (result != null && decimal.TryParse(result.ToString(), out remainingAmount))
            {
                return remainingAmount;
            }

            return remainingAmount;
        }
        private decimal GetCurrentAmount(int budgetID)
        {
            decimal remainingAmount = 0;
            var con = Configuration.getInstance().getConnection();
            SqlCommand cmd = new SqlCommand("SELECT RemainingAmount FROM Budget WHERE BudgetID = @BudgetID", con);
            cmd.Parameters.AddWithValue("@BudgetID",budgetID);
            object result = cmd.ExecuteScalar();
            if (result != null && decimal.TryParse(result.ToString(), out remainingAmount))
            {
                return remainingAmount;
            }

            return remainingAmount;
        }
        private void UpdateCheque(string updatedChequeNumber, string updatedBankName, string oldChequeNumber)
        {
            // Connect to the database
            var con = Configuration.getInstance().getConnection();

            // Define the update query
            string updateChequeQuery = @"UPDATE Cheque 
                                SET ChequeNumber = @UpdatedChequeNumber, 
                                    BankName = @UpdatedBankName 
                                WHERE ChequeNumber = @OldChequeNumber";

            // Create a SqlCommand object with the update query
            SqlCommand cmdUpdateCheque = new SqlCommand(updateChequeQuery, con);

            // Set the parameters
            cmdUpdateCheque.Parameters.AddWithValue("@UpdatedChequeNumber", updatedChequeNumber);
            cmdUpdateCheque.Parameters.AddWithValue("@UpdatedBankName", updatedBankName);
            cmdUpdateCheque.Parameters.AddWithValue("@OldChequeNumber", oldChequeNumber);

            // Execute the update query
            cmdUpdateCheque.ExecuteNonQuery();
        }
        private void UpdateCreditCard(string updatedCardNumber, string updatedBankName,string updatedTransRef, string oldCardNumber)
        {
            var con = Configuration.getInstance().getConnection();
            string updateCreditQuery = @"UPDATE CreditCard 
                                SET CardNumber = @UpdatedCardNumber, 
                                    BankName = @UpdatedBankName, 
                                    TransactionReference = @updatedTransRef
                                WHERE CardNumber = @oldCardNumber";

            // Create a SqlCommand object with the update query
            SqlCommand cmdUpdateCreditCard = new SqlCommand(updateCreditQuery, con);

            // Set the parameters
            cmdUpdateCreditCard.Parameters.AddWithValue("@UpdatedCardNumber", updatedCardNumber);
            cmdUpdateCreditCard.Parameters.AddWithValue("@UpdatedBankName", updatedBankName);
            cmdUpdateCreditCard.Parameters.AddWithValue("@UpdatedTransRef", updatedTransRef);
            cmdUpdateCreditCard.Parameters.AddWithValue("@oldCardNumber", oldCardNumber);

            // Execute the update query
            cmdUpdateCreditCard.ExecuteNonQuery();
        }
        private void UpdateOnlines(string updatedAccountNumber, string updatedBankName, string updatedTransRef, string oldAccountNumber)
        {
            var con = Configuration.getInstance().getConnection();
            string updateOnlineQuery = @"UPDATE Onlines 
                                SET AccountNumber = @UpdatedAccountNumber, 
                                    BankName = @UpdatedBankName ,
                                    TransactionReference = @updatedTransRef
                                WHERE AccountNumber = @oldAccountNumber";

            // Create a SqlCommand object with the update query
            SqlCommand cmdUpdateOnline = new SqlCommand(updateOnlineQuery, con);

            // Set the parameters
            cmdUpdateOnline.Parameters.AddWithValue("@UpdatedAccountNumber", updatedAccountNumber);
            cmdUpdateOnline.Parameters.AddWithValue("@UpdatedBankName", updatedBankName);
            cmdUpdateOnline.Parameters.AddWithValue("@UpdatedTransRef", updatedTransRef);
            cmdUpdateOnline.Parameters.AddWithValue("@oldAccountNumber", oldAccountNumber);

            // Execute the update query
            cmdUpdateOnline.ExecuteNonQuery();
        }
        private void updateCheque_Click(object sender, EventArgs e)
        {

            string oldChequeNumber = ChequeNoUpdate.Text;
            string updatedChequeNumber = chequeNo.Text;
            string updatedBankName = nameBank.Text;
            UpdateCheque(updatedChequeNumber, updatedBankName, oldChequeNumber);

            MessageBox.Show("Cheque information updated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
             DisplayCheque();
        }

        private void updatedCheque_Click(object sender, EventArgs e)
        {
            string oldChequeNumber = updated.Text;
            string updatedChequeNumber = ChequeNum.Text;
            string updatedBankName = BankNam.Text;
            UpdateCheque(updatedChequeNumber, updatedBankName, oldChequeNumber);
            ChequeDisplay();
            MessageBox.Show("Cheque information updated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
          //  DisplayCheque();
        }

        private void updatebtn_Click(object sender, EventArgs e)
        {
            string oldCardNumber = updatedCredit.Text;
            string updatedCardNumber = NumbCard.Text;
            string updatedBankName = NaamBank.Text;
            string updatedTransRef = RefTrans.Text;

            UpdateCreditCard(updatedCardNumber, updatedBankName, updatedTransRef, oldCardNumber);
            CardDisplay();

            MessageBox.Show("Credit Card information updated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);

        }

        private void button47_Click_1(object sender, EventArgs e)
        {
            string transactionType = comboBoxtrans.Text;
            string budgetId  = comboBox15.SelectedItem.ToString();
            PopulateCombo();
            comboBoxtrans.Visible = false;
            comboBox15.Visible = false;
            button47.Visible = false;
            label61.Visible = false;
            label59.Visible = true;
            label60.Visible = true;
            label95.Visible = false;
            MerchantcomboBox.Visible = true;
            comboBoxPayment.Visible = true;
            submit.Visible = true;
        }

        private void updatebtnn_Click(object sender, EventArgs e)
        {
            string oldCardNumber = CreditUpdt.Text;
            string updatedCardNumber = CardNo.Text;
            string updatedBankName = BankName.Text;
            string updatedTransRef = TransRef.Text;

            UpdateCreditCard(updatedCardNumber, updatedBankName, updatedTransRef,oldCardNumber);
            DisplayCard();

            MessageBox.Show("Credit Card information updated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);

        }

        private void updatOnlin_Click(object sender, EventArgs e)
        {
            string oldAccountNumber = OnlineUpdt.Text;
            string updatedAccountNumber = AccountNum.Text;
            string updatedBankName = NameBankk.Text;
            string updatedTransRef = ReferTransc.Text;
            UpdateOnlines(updatedAccountNumber, updatedBankName,updatedTransRef,oldAccountNumber);
            DisplayOnlines();
            MessageBox.Show("Onlines information updated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void OnlinUpdt_Click(object sender, EventArgs e)
        {
            string oldAccountNumber = updatAccount.Text;
            string updatedAccountNumber = AccNum.Text;
            string updatedBankName = NameOfBank.Text;
            string updatedTransRef = TransRefer.Text;
            UpdateOnlines(updatedAccountNumber, updatedBankName, updatedTransRef, oldAccountNumber);
            DisplayOnline(); 

            MessageBox.Show("Onlines information updated successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);

        }

        private void button51_Click(object sender, EventArgs e)
        {
            ShowReport();

        }
        private void ShowReport()
        {
            ReportDocument r = new ReportDocument();
            string path = Application.StartupPath;
            string reportpath = @"AuditResult.rpt";
            string fpath = Path.Combine(path, reportpath);
            r.Load(fpath);
            crystalReportViewer1.ReportSource = r;
        }

        private void button48_Click_1(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage42;
        }

        private void button69_Click(object sender, EventArgs e)
        {
            ShowReport2();
        }
        private void ShowReport2()
        {
            ReportDocument r = new ReportDocument();
            string path = Application.StartupPath;
            string reportpath = @"FraudAlerts.rpt";
            string fpath = Path.Combine(path, reportpath);
            r.Load(fpath);
            crystalReportViewer1.ReportSource = r;
        }

        private void button70_Click(object sender, EventArgs e)
        {
            ShowReport3();
        }
        private void ShowReport3()
        {
            ReportDocument r = new ReportDocument();
            string path = Application.StartupPath;
            string reportpath = @"CountOfMerchant.rpt";
            string fpath = Path.Combine(path, reportpath);
            r.Load(fpath);
            crystalReportViewer1.ReportSource = r;
        }

        private void button71_Click(object sender, EventArgs e)
        {
            ShowReport4();
        }
        private void ShowReport4()
        {
            ReportDocument r = new ReportDocument();
            string path = Application.StartupPath;
            string reportpath = @"Transaction.rpt";
            string fpath = Path.Combine(path, reportpath);
            r.Load(fpath);
            crystalReportViewer1.ReportSource = r;
        }

        private void button72_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage4;
        }

        private void button73_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage27;
        }

        private void button74_Click(object sender, EventArgs e)
        {
            tabControl1.SelectedTab = tabPage27;

        }

        private void button75_Click(object sender, EventArgs e)
        {
            ShowReport5();
        }
        private void ShowReport5()
        {
            ReportDocument r = new ReportDocument();
            string path = Application.StartupPath;
            string reportpath = @"Installmets.rpt";
            string fpath = Path.Combine(path, reportpath);
            r.Load(fpath);
            crystalReportViewer1.ReportSource = r;
        }

    }
}
