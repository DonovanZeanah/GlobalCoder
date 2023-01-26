using Microsoft.VisualStudio.TestTools.UnitTesting;
using MilitaryClassModels;
using System;
using System.Diagnostics;
using Shouldly;

namespace MilitaryClassTests
{
    

    [TestClass]
    public class UnitTest1
    {
        private const string FIRST_NAME_1 = "A";
        private const string LAST_NAME_1 = "LN1";
        private const string FIRST_NAME_2 = "B";
        private const string LAST_NAME_2 = "LN2";
        private DateTime DT_NOW = DateTime.Now;
        private DateTime DT_YESTERDAY = DateTime.Now.AddDays(-1);
        private const string BRANCH_AIRFORCE = "Air Force";
        private const string BRANCH_ARMY = "Army";
        private const string RANK_MSGT = "MSGT";
        private const string RANK_SRA = "SRA";
        private const int YEARS_OF_SERVICE15 = 15;
        private const int YEARS_OF_SERVICE20 = 20;

        private Civilian c1 = null;
        private Civilian c2 = null;
        private Civilian c3 = null;
        private Servicemember s0 = null;
        private Servicemember s1 = null;
        private Servicemember s2 = null;
        private Servicemember s3 = null;

        private Civilian GenerateCivilian(string firstName, string lastName, DateTime dob)
        {
            var c = new Civilian();
            c.FirstName = firstName;
            c.LastName = lastName;
            c.DateOfBirth = dob;
            return c;
        }

        private Servicemember GenerateServiceMember(string firstName, string lastName
                                                    , DateTime dob, string rank
                                                    , int yearsOfService, string branch)
        {
            var sm = new Servicemember();
            sm.FirstName = firstName;
            sm.LastName = lastName;
            sm.DateOfBirth = dob;
            sm.Rank = rank;
            sm.YearsOfService = yearsOfService;
            sm.Branch = branch;
            return sm;
        }


        [TestInitialize]
        public void TestInitialize()
        {
            c1 = GenerateCivilian(FIRST_NAME_1, LAST_NAME_1, DT_YESTERDAY);
            c2 = GenerateCivilian(FIRST_NAME_2, LAST_NAME_2, DT_NOW);
            c3 = GenerateCivilian(FIRST_NAME_2, LAST_NAME_2, DT_NOW);
            s1 = GenerateServiceMember(FIRST_NAME_1, LAST_NAME_1, DT_YESTERDAY, RANK_MSGT, YEARS_OF_SERVICE20, BRANCH_AIRFORCE);
            s2 = GenerateServiceMember(FIRST_NAME_2, LAST_NAME_2, DT_NOW, RANK_MSGT, YEARS_OF_SERVICE15, BRANCH_AIRFORCE);
            s3 = GenerateServiceMember(FIRST_NAME_2, LAST_NAME_2, DT_NOW, RANK_MSGT, YEARS_OF_SERVICE20, BRANCH_AIRFORCE);
            s0 = s1;
        }


        [TestMethod]
        public void TestPersonEquality()
        {
            // Arrange 
            // Act
            //nothing to do here...

            //possible inputs
            //should fail
            //Not of right type
            Assert.AreNotEqual(c2, "Nada");
            //Null type
            Assert.AreNotEqual(c2, null);
            //correct type but different properties
            Assert.AreNotEqual(c1, c2);
            //should pass
            //correct type and properties but different memory address
            Assert.AreEqual(c2, c3);
            //calling equals method directly
            Assert.IsTrue(c2.Equals(c3));
        }

        [TestMethod]
        public void TestCivilianEquality()
        {
            // Arrange
            // Act

            //possible inputs
            //should fail
            //Not of right type
            Assert.AreNotEqual(c2, "Nada");
            //Null type
            Assert.AreNotEqual(c2, null);
            // Same parent type but not same type
            Assert.AreNotEqual(c2, s1);

            //correct type but different properties
            Assert.AreNotEqual(c1, c2);
            //should pass
            //correct type and properties but different memory address
            Assert.AreEqual(c2, c3);
            //calling equals method directly
            Assert.IsTrue(c2.Equals(c3));
        }

        [TestMethod]
        public void TestServicememberEquality()
        {
            // Arrange
            
            // Act

            //possible inputs
            //should fail
            //Not of right type
            Assert.AreNotEqual(s2, "Nada");
            //Null type
            Assert.AreNotEqual(s2, null);
            // Same parent type but not same type
            Assert.AreNotEqual(s2, c1);

            //correct type but different years of service
            Assert.AreNotEqual(s2, s3);
            s3.YearsOfService = s2.YearsOfService;
            Assert.AreEqual(s2, s3);

            //correct type but different rank
            s3.Rank = RANK_SRA;
            Assert.AreNotEqual(s2, s3);
            s3.Rank = s2.Rank;
            Assert.AreEqual(s2, s3);

            //correct type but different branch
            s3.Branch = BRANCH_ARMY;
            Assert.AreNotEqual(s2, s3);
            s3.Branch = s2.Branch;
            Assert.AreEqual(s2, s3);

            //should pass
            //correct type and properties but different memory address
            Assert.AreEqual(s0, s1);
            //calling equals method directly
            Assert.IsTrue(s1.Equals(s0));
        }

        [TestMethod]
        public void TestCalculate()
        {
            //arrange
            var hoursWorked20 = 20;
            var hoursWorked40 = 40;
            var hoursWorked60 = 60;
            var payRate = 10;

            var expectedServiceMemberPay = 400;
            var expectedCivilianPay20 = 200;
            var expectedCivilianPay40 = 400;
            var expectedCivilianPay60 = 700;

            //act
            var pay = c1.CalculatePay(payRate, hoursWorked20);
            Assert.AreEqual(expectedCivilianPay20, pay, 0.00001, $"Pay was not correct: expected {expectedCivilianPay20} got {pay}");
            pay.ShouldBeGreaterThanOrEqualTo(0);
            pay.ShouldBe(expectedCivilianPay20);

            pay = c1.CalculatePay(payRate, hoursWorked40);
            Assert.AreEqual(expectedCivilianPay40, pay);

            pay = c1.CalculatePay(payRate, hoursWorked60);
            Assert.AreEqual(expectedCivilianPay60, pay);

            pay = s1.CalculatePay(payRate, hoursWorked20);
            Assert.AreEqual(expectedServiceMemberPay, pay);

            pay = s1.CalculatePay(payRate, hoursWorked40);
            Assert.AreEqual(expectedServiceMemberPay, pay);

            pay = s1.CalculatePay(payRate, hoursWorked60);
            Assert.AreEqual(expectedServiceMemberPay, pay);
        }

        [TestMethod]
        public void TestStringToSoldiers()
        {
            string soldier1 = "Stonewall | Jackson | 1845-02-16 | General | Army | 15";
            string soldier2 = "Michael|Scott|1991-10-18|CPO|Navy|13";

            var result = Servicemember.GetServicememberFromString(soldier1);
            result.ShouldNotBeNull("Service member should not be null");

            result.ShouldBeOfType<Servicemember>("Make sure the return type is a service member!");

            //should have firstname
            result.FirstName.ShouldNotBeNull();
            result.FirstName.ShouldBe("Stonewall");

            //should have lastName
            result.LastName.ShouldNotBeNull();
            result.LastName.ShouldBe("Jackson");

            //should have dob
            result.DateOfBirth.ShouldBeLessThan(DateTime.Now);
            result.DateOfBirth.ShouldBe(new DateTime(1845, 2, 16));

            //should have rank
            result.Rank.ShouldNotBeNull();
            result.Rank.ShouldBe("General");

            //should have branch
            result.Branch.ShouldNotBeNull();
            result.Branch.ShouldBe("Army");
            //should have Years Or service
            result.YearsOfService.ShouldBeGreaterThanOrEqualTo(0);
        }
    }
}

//Not used anymore:
//how do you declare equality property by property (we used this for learning)
// Assert
// firstName = firstName
// lastName = lastName
// DOB = DOB
//Assert.AreEqual(c1.FirstName, c2.FirstName);
//Assert.AreEqual(c1.LastName, c2.LastName);
//Assert.AreEqual(c1.DateOfBirth, c2.DateOfBirth);

//Assert.AreEqual(c3.FirstName, c2.FirstName);
//Assert.AreEqual(c3.LastName, c2.LastName);
//Assert.AreEqual(c3.DateOfBirth, c2.DateOfBirth);

//[TestMethod]
//public void TestFirstName()
//{
//    //arrange
//    Person p = new Civilian();
//    //act
//    p.FirstName = "Test";
//    //assert
//    Assert.AreEqual(p.FirstName, "Test");
//}

//[TestMethod]
//public void TestFirstNameNull()
//{
//    //arrange
//    Person p = new Civilian();
//    //act
//    p.FirstName = null;
//    //assert exception is thrown
//}