import { put, takeEvery } from "redux-saga/effects";
import axios from "axios";

const config = {
  headers: { "Content-Type": "application/json" },
  withCredentials: true,
};
//ADD_DEPENDENT to fire with /api/registration/dependent route
function* addDependent(action) {
  try {
    console.log('This is action.payload in addDependent: ', action.payload);
    yield axios.post("/api/register/dependent", action.payload, config);
    yield put({ type: "GET_DEPENDENTS" });
  } catch (error) {
    console.log("Error POSTING dependent registration:", error);
  }
}

function* sendDependentEmail(action) {
  try {
    yield axios.post("/api/register/dependent/email", action.payload, config);
  } catch (error) {
    console.log("Error in saga POST for dependent email:", error);
  }
}
// Check if user's token is valid
function* tokenCheck(action) {
  try {
    console.log('this is action.payload: ', action.payload);
    const check = yield axios.get(`/api/register/dependent/${action.payload}`);
    console.log('After axios get: ', check);
    yield put({ type: "SET_TOKEN_CHECK", payload: check.data });
  } catch (error) {
    console.log("Error in checking token:", error);
  }
}

// ADD_DEPENDENT to connect with client-side input values
function* dependentSaga() {
  yield takeEvery("ADD_DEPENDENT", addDependent);
  yield takeEvery("SEND_DEPENDENT_EMAIL", sendDependentEmail);
  yield takeEvery("TOKEN_CHECK", tokenCheck);
}

export default dependentSaga;
