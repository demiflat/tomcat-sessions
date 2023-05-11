package org.orbeon.session.tomcat;

import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/tomcat")
public class ClusteredServlet extends HttpServlet {

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String local = req.getLocalAddr();
        Integer count = 1;
        if(session.isNew()) {
            session.setAttribute(ClusteredServlet.class.getName(), count);
        } else {
            count = (Integer)session.getAttribute(ClusteredServlet.class.getName());
            session.setAttribute(ClusteredServlet.class.getName(), ++count);
        }

        String response = new StringBuilder().append(local).append(":").append(count).toString();
        PrintWriter writer = resp.getWriter();
        writer.println(response);
        writer.close();
    }
}
