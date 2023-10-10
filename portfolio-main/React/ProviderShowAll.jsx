import React, { useState, useEffect } from "react";
import { ProviderGetAllInfo } from "../../services/providersService";
import { Card } from "react-bootstrap";
import ProviderCard from "./ProviderShowAllCard";
import PropTypes from "prop-types";
import "./ProvidersShowAll.css";
import debug from "WePair-debug";

const _logger = debug.extend("ProviderShowAll");

function ProviderShowAll() {
  const [providerData, setProviderData] = useState({
    arrayOfProviders: [],
    providerComponents: [],
    totalResults: 0,
    pageIndex: 1,
    pageSize: 9,
  });

  const [inputText, setInputText] = useState("");

  const mapProvider = (sendProvider) => {

    if (!sendProvider || sendProvider === null) {
    
      return null;
    }
    return (
      <ProviderCard  providerCard={sendProvider} key={"ListA-" + sendProvider.id}></ProviderCard>
    );
  };

  useEffect(() => {
    
    ProviderGetAllInfo(providerData.pageIndex - 1, providerData.pageSize).then(onProviderSuccess).catch(onProviderFail);
  
  }, []);

  function onProviderSuccess(response) {
    
    let { pagedItems, totalCount } = response.item;
    
    setProviderData((prevState) => {
      
      let clone = { ...prevState };
      clone.arrayOfProviders = pagedItems;
      clone.providerComponents = pagedItems.map(mapProvider);
      clone.totalResults = totalCount;
      
      return clone;
    });
  }

  function onProviderFail(err) {
    _logger(err);
  }

  const inputHandler = (e) => {
    
    const userInput = e.target.value.toLowerCase();
    
    setInputText(userInput);
  };

  useEffect(() => {
    const filteredArray = providerData.arrayOfProviders.filter(filterFunction);

    function filterFunction(provider) {
      if (inputText === "") {
        return true;
      }
      const Provider =
        provider?.tittle?.name +
        provider?.userData?.firstName +
        " " +
        provider?.userData?.mi +
        " " +
        provider?.userData?.lastName;
      
      const providerName = Provider.toLowerCase();
      
      return providerName.includes(inputText);
    }

    setProviderData((prevState) => {
      
      let newState = { ...prevState };
      
      newState.providerComponents = filteredArray.map(mapProvider);
      
      return newState;
    });
  }, [inputText, providerData.arrayOfProviders]);

  return (
    <React.Fragment>
      <div className="container">
        <Card className=" bg-primary text-white">
          <Card.Body>
            <div className="Providers-Search">
              <h1 className="">Providers</h1>
              <input
                className="Providers-SearchBar"
                type="text"
                onChange={inputHandler}
                placeholder="Search For Providers"
              />
            </div>
          </Card.Body>
        </Card>

        <div className="row">{providerData.providerComponents}</div>
      </div>
    </React.Fragment>
  );
}

ProviderShowAll.propTypes = {
  ProviderCard: PropTypes.elementType,
  pagedItems: PropTypes.element,
  Provider: PropTypes.element,
  userData: PropTypes.element,
  firstName: PropTypes.string,
  lastName: PropTypes.string,
  mi: PropTypes.string,
};

export default ProviderShowAll;
