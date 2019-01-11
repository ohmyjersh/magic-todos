import {useState} from 'react';

export const useApiWithData = (apiFunc, statusCodes, onSuccessCallBack) => _useApi(apiFunc, statusCodes, onSuccessCallBack, true)
export const useApi = (apiFunc, statusCodes, onSuccessCallBack) => _useApi(apiFunc, statusCodes, onSuccessCallBack, false)

const _useApi = (apiFunc, statusCodes, onSuccessCallBack, parseResponse = false) => {
  const [isLoading, setIsLoading] = useState(false);
  const [isError, setIsError] = useState(false);

  const fetchData = async data => {
    setIsError(false);
    setIsLoading(true);

    try {
      const response = await apiFunc(data);
      if(statusCodes.filter(x => x === parseInt(response.status)).length > 0)
      {
        setIsLoading(false);
        if(parseResponse){
        const json = await response.json() || {};
        if(!!onSuccessCallBack && typeof onSuccessCallBack === 'function')
          await onSuccessCallBack(json)
        return json;
      } 
      else {
        if(!!onSuccessCallBack && typeof onSuccessCallBack === 'function')
          await onSuccessCallBack()
     }}
      else {
        setIsLoading(false);
        setIsError(true);
      }
    } catch (error) {
      setIsLoading(false);
      setIsError(true);
    }
  };

  const doCall = async data=> {
   return await fetchData(data);
  };

  return [ isLoading, isError, doCall ];
};
