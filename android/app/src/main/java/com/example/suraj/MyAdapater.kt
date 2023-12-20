package com.example.suraj

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import android.content.Intent
import android.widget.RemoteViews
import androidx.recyclerview.widget.RecyclerView

class MyAdapater(private val stringList: List<String>): RecyclerView.Adapter<MyAdapater.MyViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val itemView = LayoutInflater.from(parent.context).inflate(R.layout.item_layout, parent, false)

        return MyViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        val currentItem = stringList[position]
        holder.tvName.setText(currentItem)
    }

    override fun getItemCount(): Int {
        return stringList.size
    }

    class MyViewHolder(itemView: View):RecyclerView.ViewHolder(itemView){
        val tvName:TextView = itemView.findViewById(R.id.tvName)
    }
}
