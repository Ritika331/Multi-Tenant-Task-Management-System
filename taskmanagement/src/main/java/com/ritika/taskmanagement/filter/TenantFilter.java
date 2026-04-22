package com.ritika.taskmanagement.filter;

import com.ritika.taskmanagement.tenant.TenantContext;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import com.ritika.taskmanagement.exception.TenantNotSetException;

import java.io.IOException;

@Component
public class TenantFilter extends OncePerRequestFilter {

    private static final String TENANT_HEADER = "X-ORG-ID";

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {

        String tenantIdHeader = request.getHeader(TENANT_HEADER);

        if (tenantIdHeader != null) {
            try {
                TenantContext.setTenantId(Long.parseLong(tenantIdHeader));
            } catch (NumberFormatException ex) {
                throw new TenantNotSetException();
            }
        }


        try {
            filterChain.doFilter(request, response);
        } finally {
            TenantContext.clear();
        }
    }
}
