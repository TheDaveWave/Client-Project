import React, { useEffect, useState } from "react";
import { useSelector } from "react-redux";
import { useDispatch } from "react-redux";
import FloatingLabel from "react-bootstrap/FloatingLabel";
import Form from "react-bootstrap/Form";
import { useHistory } from "react-router-dom";
import Dropdown from "react-bootstrap/Dropdown";
import { DropdownButton, ButtonGroup } from "react-bootstrap";
import UpdatedNavBar from "../Nav/Nav";

function AddDiscount() {
  //grab all categories
  const allCategories = useSelector((store) => store.categories);
  // grab all vendors
  const allVendors = useSelector((store) => store.vendors);

  const dispatch = useDispatch();
  const history = useHistory();
  const [vendorId, setVendorId] = useState(1);
  const [description, setDescription] = useState("");
  const [startDate, setStartDate] = useState("");
  const [expDate, setExpDate] = useState("");
  const [discountCode, setDiscountCode] = useState("N/A");
  const [categoryId, setCategoryId] = useState(1);
  const [isShown, setIsShown] = useState("True");
  const [isRegional, setIsRegional] = useState("False");

  const addDiscount = (event) => {
    // console.log("In addDiscount() vendorId;", vendorId, "categoryId:", categoryId);
    event.preventDefault();

    dispatch({
      type: "ADD_DISCOUNT",
      payload: {
        vendorId: vendorId,
        description: description,
        startDate: startDate,
        expDate: expDate,
        discountCode: discountCode,
        categoryId: categoryId,
        isShown: isShown,
        isRegional: isRegional,
      },
    });
    // Reset the form values.
    setVendorId(1);
    setCategoryId(1);
    setDescription("");
    setStartDate("");
    setExpDate("");
    setDiscountCode("N/A");
  };

  useEffect(() => {
    dispatch({ type: "FETCH_VENDORS" });
    dispatch({ type: "GET_CATEGORIES" });
    // console.log("categories", allCategories);
    // console.log("vendors", allVendors);
  }, []);

  return (
    <>
      <UpdatedNavBar />
      <div className="container text-center">
        <h2 className="text-primary"> Add Discount</h2>
        <Dropdown onSelect={(eventKey) => setVendorId(eventKey)}>
          <DropdownButton
            id="category-select-dropdown"
            title="Vendor"
            as={ButtonGroup}
          >
            {allVendors.map((vendor) => {
              return (
                <Dropdown.Item eventKey={vendor.id}>
                  {vendor.name}
                </Dropdown.Item>
              );
            })}
          </DropdownButton>
        </Dropdown>
        <form onSubmit={addDiscount}>
          <FloatingLabel
            className="mb-1 text-primary"
            controlId="floatingFirstName"
            label="Description"
          >
            <Form.Control
              type="text"
              placeholder="name@example.com"
              value={description}
              onChange={(event) => setDescription(event.target.value)}
              autoFocus
            />
          </FloatingLabel>
          <FloatingLabel
            className="mb-1 text-primary"
            controlId="floatingFirstName"
            label="Start Date"
          >
            <Form.Control
              type="date"
              placeholder="name@example.com"
              value={startDate}
              onChange={(event) => setStartDate(event.target.value)}
              autoFocus
            />
          </FloatingLabel>
          <FloatingLabel
            className="mb-1 text-primary"
            controlId="floatingFirstName"
            label="Expiration Date"
          >
            <Form.Control
              type="date"
              placeholder="name@example.com"
              value={expDate}
              onChange={(event) => setExpDate(event.target.value)}
              autoFocus
            />
          </FloatingLabel>
          <FloatingLabel
            className="mb-1 text-primary"
            controlId="floatingFirstName"
            label="Discount Code (If Applicable)"
          >
            <Form.Control
              type="text"
              placeholder="name@example.com"
              value={discountCode}
              onChange={(event) => setDiscountCode(event.target.value)}
              autoFocus
            />
          </FloatingLabel>
          <Dropdown onSelect={(eventKey) => setCategoryId(eventKey)}>
            <DropdownButton
              id="category-select-dropdown"
              title="Category"
              as={ButtonGroup}
            >
              {allCategories.map((category) => {
                return (
                  <Dropdown.Item eventKey={category.id}>
                    {category.name}
                  </Dropdown.Item>
                );
              })}
            </DropdownButton>
          </Dropdown>
          <br />
          <button type="submit" className="btn btn-primary">
            Add Discount
          </button>
        </form>
      </div>
    </>
  );
}

export default AddDiscount;