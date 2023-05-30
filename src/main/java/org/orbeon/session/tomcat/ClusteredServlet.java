package org.orbeon.session.tomcat;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.cache.Cache;
import javax.cache.CacheManager;
import javax.cache.Caching;
import javax.cache.configuration.MutableConfiguration;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serializable;
import java.net.URI;

import static java.util.Objects.nonNull;

@WebServlet("/tomcat")
public class ClusteredServlet extends HttpServlet {
    public static final String ORBEON = "orbeon";
    String sessionKey = ClusteredServlet.class.getName();

    String hostAddress = "";
    Cache<String, Serializable> cache;

    @Override
    public void init(ServletConfig config) throws ServletException {
    }

    boolean isBlank(String string) {
        return string == null || string.trim().isEmpty();
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Integer count = Integer.class.cast(session.getAttribute(sessionKey));

        if(session.isNew()) {
            count = 0;
        } else {
            if(count == null) {
                // this shouldn't happen, make it obvious
                count = Integer.MIN_VALUE;
            }
            session.setAttribute(ClusteredServlet.class.getName(), ++count);
        }

        session.setAttribute(sessionKey, count);

        PrintWriter writer = resp.getWriter();
        writePayload(count, req.getLocalName(), req.getLocalAddr(), req.getLocalPort(), writer);
        writer.close();
    }

    private void writePayload(Integer count, String localName, String localIp, Integer localPort, PrintWriter writer) {
        writer
                .append('{')
                .append("\"")
                .append("count")
                .append("\"")
                .append(":")
                .append(String.valueOf(count))
                .append(",")
                .append("\"")
                .append("localName")
                .append("\"")
                .append(":")
                .append("\"")
                .append(localName)
                .append("\"")
                .append(",")
                .append("\"")
                .append("localName")
                .append("\"")
                .append(":")
                .append("\"")
                .append(localIp)
                .append("\"")
                .append(",")
                .append("\"")
                .append("localPort")
                .append("\"")
                .append(":")
                .append("\"")
                .append(String.valueOf(localPort))
                .append("\"")
                .append('}');
    }
}
