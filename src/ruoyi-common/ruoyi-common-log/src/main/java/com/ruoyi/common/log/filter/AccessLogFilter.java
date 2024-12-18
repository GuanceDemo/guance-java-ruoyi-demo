package com.ruoyi.common.log.filter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class AccessLogFilter implements Filter {
    private static final Logger logger = LoggerFactory.getLogger(AccessLogFilter.class);
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletResponse response = (HttpServletResponse)servletResponse;
        HttpServletRequest request = (HttpServletRequest)servletRequest;

        logger.info("method:{},uri:{},ContextPath:{},requestUrl:{},queryStr:{}",request.getMethod(),request.getRequestURI().toString(),request.getContextPath(),request.getRequestURL().toString(),request.getQueryString());

        filterChain.doFilter(request,response);
    }
}
