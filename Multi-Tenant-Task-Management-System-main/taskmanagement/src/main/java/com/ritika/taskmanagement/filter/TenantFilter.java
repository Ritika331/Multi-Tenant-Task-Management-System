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
    protected boolean shouldNotFilter(HttpServletRequest request) {
        // Skip this filter for auth endpoints and organization creation
        String path = request.getRequestURI();
        return path.startsWith("/auth/") || path.equals("/organizations");
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {

        // Tenant is now set by JwtAuthenticationFilter from JWT token
        // This filter is kept for backward compatibility but tenant ID
        // should come from authentication, not from header

        try {
            filterChain.doFilter(request, response);
        } finally {
            TenantContext.clear();
        }
    }
}
