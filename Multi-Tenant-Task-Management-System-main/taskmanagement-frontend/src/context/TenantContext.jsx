import { createContext, useContext, useState } from "react";

const TenantContext = createContext();

export const TenantProvider = ({ children }) => {
  const [orgId, setOrgId] = useState(1);

  return (
    <TenantContext.Provider value={{ orgId, setOrgId }}>
      {children}
    </TenantContext.Provider>
  );
};

export const useTenant = () => useContext(TenantContext);
