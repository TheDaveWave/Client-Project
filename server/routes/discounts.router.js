const express = require("express");
const pool = require("../modules/pool");
const {
  rejectUnauthenticated,
} = require("../modules/authentication-middleware");
const {
  rejectUnauthorizedUser,
} = require("../modules/authorization-middleware");
const router = express.Router();

// This GET will return all discounts with their parent vendor info and category info
// All relevent info for the member discount page
router.get("/member", rejectUnauthenticated, (req, res) => {
  // select all from discounts with calculated number of discount uses for 7 days, 30 days, 1 year and all time
  const query = `SELECT "discounts"."id" as "discount_id", "vendor_id", "description", "start_date", "expiration_date", "discount_code", "category_id", "is_regional", "vendors"."name" as "vendor_name", "address", "city", "state_code", "zip", "categories"."name" as "category_name", "icon_class"
  FROM "discounts"
  JOIN "vendors" ON "vendors"."id" = "vendor_id"
  JOIN "categories" ON "categories"."id" = "category_id"
  WHERE "is_shown"=true;`;
  pool
    .query(query)
    .then((result) => {
      // return results from query
      res.send(result.rows);
    })
    .catch((err) => {
      // log the error if one occurs
      console.log("Error in getting current discounts: ", err);
    });
}); // End GET discounts

// This GET will return all discounts in the database (for admin page)
router.get("/admin", rejectUnauthenticated, (req, res) => {
  // select all from discounts with calculated number of discount uses for 7 days, 30 days, 1 year and all time
  const query = `SELECT "discounts".*,
	count("discounts_tracked"."id") AS "discounts_all_time",
	count(*) FILTER (WHERE "discounts_tracked"."date" BETWEEN (CURRENT_DATE - INTERVAL '7 days') AND CURRENT_DATE) AS "7_day_count",
	count(*) FILTER (WHERE "discounts_tracked"."date" BETWEEN (CURRENT_DATE - INTERVAL '30 days') AND CURRENT_DATE) AS "30_day_count",
	count(*) FILTER (WHERE "discounts_tracked"."date" BETWEEN (CURRENT_DATE - INTERVAL '1 year') AND CURRENT_DATE) AS "1_year_count"
	FROM "discounts"
	JOIN "discounts_tracked" ON "discounts_tracked"."discount_id"="discounts"."id"
	GROUP BY "discounts_tracked"."discount_id", "discounts"."id"
	ORDER BY "discounts"."id";`;
  pool
    .query(query)
    .then((result) => {
      // return results from query
      res.send(result.rows);
    })
    .catch((err) => {
      // log the error if one occurs
      console.log("Error in getting current discounts: ", err);
    });
}); // End GET discounts

// This POST will add a new discount to the discount table
router.post("/", rejectUnauthenticated, (req, res) => {
  const vendorId = req.body.vendorId;
  const description = req.body.description;
  const startDate = req.body.startDate ? req.body.startDate : null;
  const expDate = req.body.expDate ? req.body.expDate : null;
  const discountCode = req.body.discountCode ? req.body.discountCode : null;
  const categoryId = req.body.categoryId;
  const isShown = req.body.isShown;
  const isRegional = req.body.isRegional;
  // POST sql query
  const query = `INSERT INTO "discounts"
                ("vendor_id", "description", "start_date", "expiration_date", discount_code, category_id, is_shown, is_regional)
                 VALUES ($1, $2, $3, $4, $5, $6 ,$7, $8);`;
  pool
    .query(query, [
      vendorId,
      description,
      startDate,
      expDate,
      discountCode,
      categoryId,
      isShown,
      isRegional,
    ])
    .then((result) => {
      // send success status
      res.sendStatus(201);
    })
    .catch((err) => {
      // Log error if one occurs
      console.log("Error in POST new discount: ", err);
      res.sendStatus(500);
    });
}); // End POST new discount

// This PUT will edit an existing discount by ID number
router.put("/", rejectUnauthenticated, (req, res) => {
  console.log("In discount PUT with: ", req.body);
  const discountId = req.body.discountId;
  const vendorId = req.body.vendorId;
  const description = req.body.description;
  const startDate = req.body.startDate ? req.body.startDate : null;
  const expDate = req.body.expDate ? req.body.expDate : null;
  const discountCode = req.body.discountCode ? req.body.discountCode : null;
  const categoryId = req.body.categoryId;
  const isShown = req.body.isShown;
  const isRegional = req.body.isRegional;
  const query = `UPDATE "discounts"
                 SET "vendor_id"=$1,
                 "description"=$2,
                 "start_date"=$3,
                 "expiration_date"=$4,
                 "discount_code"=$5,
                 "category_id"=$6,
                 "is_shown"=$7,
                 "is_regional"=$8
                 WHERE "id"=$9;`;
  pool
    .query(query, [
      vendorId,
      description,
      startDate,
      expDate,
      discountCode,
      categoryId,
      isShown,
      isRegional,
      discountId,
    ])
    .then((result) => {
      // Send success status
      res.sendStatus(200);
    })
    .catch((err) => {
      // log error and send back error code if error occurred
      console.log("Error editing discount: ", err);
      res.sendStatus(500);
    });
}); // End edit discount PUT

// Delete a discount by discount ID
router.delete("/:discountid", rejectUnauthenticated, (req, res) => {
  console.log("In delete a discount with: ", req.params.discountid);
  const discountId = req.params.discountid;
  const query = `DELETE FROM "discounts"
                 WHERE "id"=$1;`;
  pool
    .query(query, [discountId])
    .then((result) => {
      // Send a success status
      res.sendStatus(200);
    })
    .catch((err) => {
      // Log error and send error status if error occurs
      console.log("Error deleting a player");
      res.sendStatus(500);
    });
}); // End delete a discount

router.get(
  "/admindiscounttracker",
  rejectUnauthenticated,
  rejectUnauthorizedUser,
  (req, res) => {
    const queryText = `SELECT "discounts_tracked"."id", "discounts"."vendor_id" as "vendor_id", "discount_id", "date" FROM "discounts_tracked"
    JOIN "discounts" ON "discounts_tracked"."discount_id"="discounts"."id";`;

    pool
      .query(queryText)
      .then((result) => {
        res.send(result.rows);
      })
      .catch((error) => {
        console.log("error caught in GET discount tracker :>> ", error);
        res.sendStatus(500);
      });
  }
);

// export the router
module.exports = router;
