package com.sharehub.web;

import com.sharehub.entity.User;
import com.sharehub.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 跳转到登录页面
     */
    @GetMapping(value = {"/", "/login"})
    public String toLogin() {
        return "login";
    }

    /**
     * 跳转到注册页面
     */
    @GetMapping("/register")
    public String toRegister() {
        return "register";
    }

    /**
     * 用户注册
     */
    @PostMapping("/register")
    @ResponseBody
    public String register(@RequestParam String username,
                          @RequestParam String password,
                          @RequestParam String email) {
        if (userService.isUsernameExists(username)) {
            return "用户名已存在";
        }
        if (userService.isEmailExists(email)) {
            return "邮箱已被注册";
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);

        userService.register(user);
        return "success";
    }

    /**
     * 用户登录
     */
    @PostMapping("/login")
    @ResponseBody
    public String login(@RequestParam String username,
                       @RequestParam String password,
                       HttpSession session) {
        User user = userService.login(username, password);
        if (user != null) {
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            return "success";
        }
        return "用户名或密码错误";
    }

    /**
     * 检查用户名是否存在
     */
    @GetMapping("/checkUsername")
    @ResponseBody
    public String checkUsername(@RequestParam String username) {
        return userService.isUsernameExists(username) ? "exists" : "available";
    }

    /**
     * 检查邮箱是否存在
     */
    @GetMapping("/checkEmail")
    @ResponseBody
    public String checkEmail(@RequestParam String email) {
        return userService.isEmailExists(email) ? "exists" : "available";
    }

    /**
     * 退出登录
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/user/login";
    }
} 