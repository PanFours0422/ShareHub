package com.sharehub.web;

import com.sharehub.entity.User;
import com.sharehub.service.UserService;
import com.sharehub.util.SmsUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Random;

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
     * 发送验证码
     */
    @PostMapping("/sendCode")
    @ResponseBody
    public String sendVerificationCode(@RequestParam String phone, HttpSession session) {
        // 生成6位随机验证码
        String code = String.format("%06d", new Random().nextInt(1000000));
        
        // 发送验证码
        String result = SmsUtil.sendVerificationCode(phone, code);
        
        // 如果发送成功，将验证码保存到session
        if (result.contains("success")) {
            session.setAttribute("verificationCode", code);
            session.setAttribute("verificationPhone", phone);
            session.setAttribute("verificationTime", System.currentTimeMillis());
            return "success";
        }
        
        return "发送失败：" + result;
    }

    /**
     * 验证验证码
     */
    @PostMapping("/verifyCode")
    @ResponseBody
    public String verifyCode(@RequestParam String phone, @RequestParam String code, HttpSession session) {
        String savedCode = (String) session.getAttribute("verificationCode");
        String savedPhone = (String) session.getAttribute("verificationPhone");
        Long savedTime = (Long) session.getAttribute("verificationTime");
        
        // 验证码5分钟内有效
        if (savedCode == null || savedPhone == null || savedTime == null ||
            !savedPhone.equals(phone) || !savedCode.equals(code) ||
            System.currentTimeMillis() - savedTime > 5 * 60 * 1000) {
            return "验证码无效或已过期";
        }
        
        return "success";
    }

    /**
     * 用户注册
     */
    @PostMapping("/register")
    @ResponseBody
    public String register(@RequestParam String username,
                          @RequestParam String email,
                          @RequestParam String phone,
                          @RequestParam String password,
                          @RequestParam String confirmPassword,
                          @RequestParam String verificationCode,
                          HttpSession session) {
        // 验证验证码
        String savedCode = (String) session.getAttribute("verificationCode");
        String savedPhone = (String) session.getAttribute("verificationPhone");
        Long savedTime = (Long) session.getAttribute("verificationTime");
        
        if (savedCode == null || savedPhone == null || savedTime == null ||
            !savedPhone.equals(phone) || !savedCode.equals(verificationCode) ||
            System.currentTimeMillis() - savedTime > 5 * 60 * 1000) {
            return "验证码无效或已过期";
        }

        // 验证用户名
        if (userService.isUsernameExists(username)) {
            return "用户名已存在";
        }

        // 验证邮箱
        if (userService.isEmailExists(email)) {
            return "邮箱已被注册";
        }

        // 验证手机号
        if (userService.isPhoneExists(phone)) {
            return "手机号已被注册";
        }

        // 验证密码
        if (!password.equals(confirmPassword)) {
            return "两次输入的密码不一致";
        }

        // 创建用户
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(password);
        user.setStatus(1);

        if (userService.register(user)) {
            // 清除验证码相关session
            session.removeAttribute("verificationCode");
            session.removeAttribute("verificationPhone");
            session.removeAttribute("verificationTime");
            return "success";
        }

        return "注册失败，请稍后重试";
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
     * 检查电话是否存在
     */
    @GetMapping("/checkPhone")
    @ResponseBody
    public String checkPhone(@RequestParam String phone) {
        return userService.isPhoneExists(phone) ? "exists" : "available";
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