/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;

public class Agenda {
    private Date offWorkDate;
    private int lrid;
    private String workDateType;
    
    private Employee emp;

    public Agenda() {
    }

    public Date getOffWorkDate() {
        return offWorkDate;
    }

    public void setOffWorkDate(Date offWorkDate) {
        this.offWorkDate = offWorkDate;
    }

    public int getLrid() {
        return lrid;
    }

    public void setLrid(int lrid) {
        this.lrid = lrid;
    }

    public String getWorkDateType() {
        return workDateType;
    }

    public void setWorkDateType(String workDateType) {
        this.workDateType = workDateType;
    }

    public Employee getEmp() {
        return emp;
    }

    public void setEmp(Employee emp) {
        this.emp = emp;
    }

    @Override
    public String toString() {
        return "Agenda{" + "offWorkDate=" + offWorkDate + ", lrid=" + lrid + ", workDateType=" + workDateType + ", emp=" + emp + '}';
    }
}
