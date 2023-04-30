using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WorkingWithADatabaseUsingADONet
{
    public class DatabaseInterop
    {
        private readonly string _connectionString;
        private SqlConnection _conn;
        private SqlCommand _cmd;
        private SqlDataAdapter _da;
        private SqlDataReader _dr;
        private DataSet _ds;
        public DatabaseInterop(string connectionString)
        {
            _connectionString = connectionString;
            
        }

        public DataSet GetAll()
        {
            var query = "SELECT * FROM Movie";
            _conn = new SqlConnection(_connectionString);

            try
            {
                if (_conn.State == ConnectionState.Closed)
                {
                    _conn.Open();
                }
                var cmd = new SqlCommand();
                cmd.Connection = _conn;
                cmd.CommandText = query;
                cmd.CommandType = CommandType.Text;
                cmd.CommandTimeout = 0;

                _da = new SqlDataAdapter();
                _da.SelectCommand = cmd;
                _ds = new DataSet();
                _da.Fill(_ds);

                return _ds;
            }
            catch (SqlException sqlex)
            {
                Debug.WriteLine($"SQL ERROR: {sqlex}");
                throw;
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Non SQL ERROR: {ex}");
                throw;
            }
            finally
            {
                _da = null;
                _dr = null;
                _ds = null;
                if (_conn.State == ConnectionState.Open)
                {
                    _conn.Close();
                }
                _conn = null;
            }
        }

        public DataSet GetAllByProcedure()
        {
            var sprocName = "dbo.GetAllMovieInfo";
            _conn = new SqlConnection(_connectionString);

            try
            {
                if (_conn.State == ConnectionState.Closed)
                {
                    _conn.Open();
                }
                var cmd = new SqlCommand();
                cmd.Connection = _conn;
                cmd.CommandText = sprocName;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 0;

                _da = new SqlDataAdapter();
                _da.SelectCommand = cmd;
                _ds = new DataSet();
                _da.Fill(_ds);

                return _ds;
            }
            catch (SqlException sqlex)
            {
                Debug.WriteLine($"SQL ERROR: {sqlex}");
                throw;
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Non SQL ERROR: {ex}");
                throw;
            }
            finally
            {
                _da = null;
                _dr = null;
                _ds = null;
                if (_conn.State == ConnectionState.Open)
                {
                    _conn.Close();
                }
                _conn = null;
            }
        }

        public DataSet Get(int id)
        {
            var query = "SELECT * FROM Movies WHERE Id = {id}";
            _conn = new SqlConnection(_connectionString);

            try
            {
                if (_conn.State == ConnectionState.Closed)
                {
                    _conn.Open();
                }
                var cmd = new SqlCommand();
                cmd.Connection = _conn;
                cmd.CommandText = query;
                cmd.CommandType = CommandType.Text;
                cmd.CommandTimeout = 0;

                _da = new SqlDataAdapter();
                _da.SelectCommand = cmd;
                _da.Fill(_ds);

                return _ds;
            }
            catch (SqlException sqlex)
            {
                Debug.WriteLine($"SQL ERROR: {sqlex}");
                throw;
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Non SQL ERROR: {ex}");
                throw;
            }
            finally
            {
                _da = null;
                _dr = null;
                _ds = null;
                if (_conn.State == ConnectionState.Open)
                {
                    _conn.Close();
                }
                _conn = null;
            }
        }
    }
}
