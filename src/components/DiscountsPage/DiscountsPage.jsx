import { useState, useEffect } from "react";
import { useSelector, useDispatch } from "react-redux";
import UpdatedNavBar from "../Nav/Nav";
import Button from "react-bootstrap/Button";
import Offcanvas from "react-bootstrap/Offcanvas";

// components
import DiscountCard from "./DiscountCard";
import DiscountFilterOffCanvas from "./DiscountFilterOffCanvas";

function DiscountsPage() {
  const dispatch = useDispatch();

  // redux stores for managing search parameters
  const selectedCities = useSelector(
    (store) => store.filter.selectedCitiesReducer
  );
  const selectedCategories = useSelector(
    (store) => store.filter.selectedCategoriesReducer
  );
  // redux store containing all available member discounts
  const allMemberDiscounts = useSelector(
    (store) => store.discounts.memberDiscountsReducer
  );
  // redux store containing current filtered list of member discounts
  const filteredDiscounts = useSelector(
    (store) => store.filter.filteredDiscountsReducer
  );

  const [showFilterOffCanvas, setShowFilterOffCanvas] = useState(false);

  


  // function filterByCity() {
  //   let discountList = [...allMemberDiscounts];

    
  //   }

  //   function filterByCategory(){
  //      // for each selected category, filter out discounts that don't match
  //     for (let category of selectedCategories) {
  //     discountList = discountList.filter((discount) => {
  //       return discount.category_id === category.id;
  //     });
  //   }

        // dispatch({ type: "SET_FILTERED_DISCOUNTS", payload: discountList });
  //   }

    
  
  
  useEffect(() => dispatch({ type: "GET_MEMBER_DISCOUNTS" }), []);
  useEffect(
    () => console.log("memberDiscounts are", allMemberDiscounts),
    [allMemberDiscounts]
  );
  // // updated filtered discount array when changes made to filter
  // useEffect(
  //   () => filterDiscounts(),
  //   [selectedCities, selectedCategories, allMemberDiscounts]
  // );

  return (
    <>
      <UpdatedNavBar />
      <div className="d-flex justify-content-center">
        <Button
          size="lg"
          variant="outline-primary"
          onClick={() => setShowFilterOffCanvas(true)}
          className="me-2 d-flex justify-content-center"
        >
          {selectedCities.length > 0 || selectedCategories.length > 0
            ? "Edit"
            : "Refine"}{" "}
          My Search
        </Button>
      </div>

      <Offcanvas
        show={showFilterOffCanvas}
        onHide={() => setShowFilterOffCanvas(false)}
      >
        <Offcanvas.Header closeButton>
          <Offcanvas.Title>Narrow Your Search</Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body>
          <DiscountFilterOffCanvas
            setShowFilterOffCanvas={setShowFilterOffCanvas}
          />
        </Offcanvas.Body>
      </Offcanvas>

      {filteredDiscounts.map((thisDiscount, index) => {
        return <DiscountCard key={index} thisDiscount={thisDiscount} />;
      })}
    </>
  );
}

export default DiscountsPage;
